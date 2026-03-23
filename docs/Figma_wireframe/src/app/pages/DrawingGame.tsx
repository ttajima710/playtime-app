import { useRef, useState, useEffect } from "react";
import { motion } from "motion/react";
import { Trash2, Star, Heart, Sparkles } from "lucide-react";
import { HomeButton } from "../components/HomeButton";

const STAMPS = [Star, Heart, Sparkles];

interface Stamp {
  id: number;
  Icon: typeof Star;
  x: number;
  y: number;
}

export function DrawingGame() {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [isDrawing, setIsDrawing] = useState(false);
  const [stamps, setStamps] = useState<Stamp[]>([]);
  const hueRef = useRef(0);
  
  // Audio state
  const audioContextRef = useRef<AudioContext | null>(null);
  const drawOscillatorRef = useRef<OscillatorNode | null>(null);
  const drawGainRef = useRef<GainNode | null>(null);

  useEffect(() => {
    const initAudio = () => {
      if (!audioContextRef.current) {
        audioContextRef.current = new AudioContext();
      }
    };
    document.addEventListener('touchstart', initAudio, { once: true });
    document.addEventListener('click', initAudio, { once: true });
    return () => {
      document.removeEventListener('touchstart', initAudio);
      document.removeEventListener('click', initAudio);
    };
  }, []);

  const playReleaseSound = () => {
    if (!audioContextRef.current) return;
    const ctx = audioContextRef.current;
    if (ctx.state === 'suspended') ctx.resume();

    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    
    osc.connect(gain);
    gain.connect(ctx.destination);
    
    osc.type = 'triangle';
    // ascending sparkle sound
    osc.frequency.setValueAtTime(400, ctx.currentTime);
    osc.frequency.exponentialRampToValueAtTime(1200, ctx.currentTime + 0.3);
    
    gain.gain.setValueAtTime(0.2, ctx.currentTime);
    gain.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.3);
    
    osc.start(ctx.currentTime);
    osc.stop(ctx.currentTime + 0.3);
  };

  const startDrawSound = () => {
    if (!audioContextRef.current) return;
    const ctx = audioContextRef.current;
    if (ctx.state === 'suspended') ctx.resume();

    // stop existing if any
    stopDrawSound();

    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    
    osc.connect(gain);
    gain.connect(ctx.destination);
    
    osc.type = 'sine';
    osc.frequency.value = 300; // baseline frequency
    
    gain.gain.value = 0.1;
    
    osc.start();
    drawOscillatorRef.current = osc;
    drawGainRef.current = gain;
  };

  const updateDrawSound = () => {
    if (drawOscillatorRef.current && audioContextRef.current) {
      // Modulate frequency slightly based on hue to make drawing sound dynamic
      const ctx = audioContextRef.current;
      const freq = 300 + (hueRef.current * 2); // 300 to 1020 Hz
      drawOscillatorRef.current.frequency.setTargetAtTime(freq, ctx.currentTime, 0.05);
    }
  };

  const stopDrawSound = () => {
    if (drawOscillatorRef.current) {
      drawOscillatorRef.current.stop();
      drawOscillatorRef.current.disconnect();
      drawOscillatorRef.current = null;
    }
    if (drawGainRef.current) {
      drawGainRef.current.disconnect();
      drawGainRef.current = null;
    }
  };

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    canvas.width = canvas.offsetWidth;
    canvas.height = canvas.offsetHeight;

    ctx.lineCap = "round";
    ctx.lineJoin = "round";
    ctx.lineWidth = 20;
    // Clean up sounds when component unmounts
    return () => {
      stopDrawSound();
    };
  }, []);

  const startDrawing = (x: number, y: number) => {
    setIsDrawing(true);
    startDrawSound();
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    ctx.beginPath();
    ctx.moveTo(x, y);
  };

  const draw = (x: number, y: number) => {
    if (!isDrawing) return;

    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    hueRef.current = (hueRef.current + 2) % 360;
    updateDrawSound();
    ctx.strokeStyle = `hsl(${hueRef.current}, 80%, 60%)`;
    ctx.lineTo(x, y);
    ctx.stroke();
  };

  const stopDrawing = (x: number, y: number) => {
    if (isDrawing) {
      stopDrawSound();
      playReleaseSound();
      const RandomStamp = STAMPS[Math.floor(Math.random() * STAMPS.length)];
      setStamps((prev) => [...prev, { id: Date.now(), Icon: RandomStamp, x, y }]);
    }
    setIsDrawing(false);
  };

  const handleMouseDown = (e: React.MouseEvent<HTMLCanvasElement>) => {
    const rect = e.currentTarget.getBoundingClientRect();
    startDrawing(e.clientX - rect.left, e.clientY - rect.top);
  };

  const handleMouseMove = (e: React.MouseEvent<HTMLCanvasElement>) => {
    const rect = e.currentTarget.getBoundingClientRect();
    draw(e.clientX - rect.left, e.clientY - rect.top);
  };

  const handleMouseUp = (e: React.MouseEvent<HTMLCanvasElement>) => {
    const rect = e.currentTarget.getBoundingClientRect();
    stopDrawing(e.clientX - rect.left, e.clientY - rect.top);
  };

  const handleTouchStart = (e: React.TouchEvent<HTMLCanvasElement>) => {
    e.preventDefault();
    const rect = e.currentTarget.getBoundingClientRect();
    const touch = e.touches[0];
    startDrawing(touch.clientX - rect.left, touch.clientY - rect.top);
  };

  const handleTouchMove = (e: React.TouchEvent<HTMLCanvasElement>) => {
    e.preventDefault();
    const rect = e.currentTarget.getBoundingClientRect();
    const touch = e.touches[0];
    draw(touch.clientX - rect.left, touch.clientY - rect.top);
  };

  const handleTouchEnd = (e: React.TouchEvent<HTMLCanvasElement>) => {
    e.preventDefault();
    const rect = e.currentTarget.getBoundingClientRect();
    const touch = e.changedTouches[0];
    stopDrawing(touch.clientX - rect.left, touch.clientY - rect.top);
  };

  const clearCanvas = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    ctx.clearRect(0, 0, canvas.width, canvas.height);
    setStamps([]);
    
    // Play a trash sound
    if (audioContextRef.current) {
      const audioCtx = audioContextRef.current;
      if (audioCtx.state === 'suspended') audioCtx.resume();
      
      const osc = audioCtx.createOscillator();
      const gain = audioCtx.createGain();
      osc.connect(gain);
      gain.connect(audioCtx.destination);
      
      osc.type = 'sawtooth';
      osc.frequency.setValueAtTime(200, audioCtx.currentTime);
      osc.frequency.exponentialRampToValueAtTime(50, audioCtx.currentTime + 0.3);
      
      gain.gain.setValueAtTime(0.2, audioCtx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 0.3);
      
      osc.start(audioCtx.currentTime);
      osc.stop(audioCtx.currentTime + 0.3);
    }
  };

  return (
    <div className="min-h-screen bg-white relative overflow-hidden">
      <canvas
        ref={canvasRef}
        onMouseDown={handleMouseDown}
        onMouseMove={handleMouseMove}
        onMouseUp={handleMouseUp}
        onMouseLeave={handleMouseUp}
        onTouchStart={handleTouchStart}
        onTouchMove={handleTouchMove}
        onTouchEnd={handleTouchEnd}
        className="absolute inset-0 w-full h-full touch-none"
      />

      {stamps.map((stamp) => (
        <motion.div
          key={stamp.id}
          initial={{ scale: 0, rotate: 0 }}
          animate={{ scale: 1, rotate: 360 }}
          transition={{ duration: 0.5, type: "spring" }}
          className="absolute pointer-events-none"
          style={{ left: stamp.x - 24, top: stamp.y - 24 }}
        >
          <stamp.Icon className="w-12 h-12 text-yellow-400 drop-shadow-lg" fill="currentColor" />
        </motion.div>
      ))}

      <motion.button
        onClick={clearCanvas}
        className="fixed bottom-8 right-8 w-20 h-20 bg-red-400 rounded-full flex items-center justify-center shadow-2xl z-10"
        whileTap={{ scale: 0.9 }}
      >
        <Trash2 className="w-10 h-10 text-white" strokeWidth={3} />
      </motion.button>

      <HomeButton />
    </div>
  );
}
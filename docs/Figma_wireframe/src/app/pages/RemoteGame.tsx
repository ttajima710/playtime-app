import { useState, useRef } from "react";
import { motion } from "motion/react";
import { HomeButton } from "../components/HomeButton";

const BUTTONS = [
  { num: 1, color: "bg-gradient-to-br from-blue-300 to-blue-400", sound: "🐶" },
  { num: 2, color: "bg-gradient-to-br from-green-300 to-green-400", sound: "🐱" },
  { num: 3, color: "bg-gradient-to-br from-yellow-300 to-yellow-400", sound: "🚗" },
  { num: 4, color: "bg-gradient-to-br from-pink-300 to-pink-400", sound: "🎵" },
  { num: 5, color: "bg-gradient-to-br from-purple-300 to-purple-400", sound: "🔔" },
  { num: 6, color: "bg-gradient-to-br from-red-300 to-red-400", sound: "🐮" },
  { num: 7, color: "bg-gradient-to-br from-orange-300 to-orange-400", sound: "🚂" },
  { num: 8, color: "bg-gradient-to-br from-teal-300 to-teal-400", sound: "🐸" },
  { num: 9, color: "bg-gradient-to-br from-indigo-300 to-indigo-400", sound: "🦆" },
  { num: 0, color: "bg-gradient-to-br from-cyan-300 to-cyan-400", sound: "🐷" },
];

const SPECIAL_BUTTONS = [
  { id: "call", emoji: "📞", color: "bg-gradient-to-br from-orange-400 to-orange-500", sound: "ring" },
  { id: "tv", emoji: "📺", color: "bg-gradient-to-br from-blue-400 to-blue-500", sound: "tv" },
  { id: "power", emoji: "⚡", color: "bg-gradient-to-br from-red-400 to-red-500", sound: "power" },
];

export function RemoteGame() {
  const [activeButton, setActiveButton] = useState<string | null>(null);
  const audioContextRef = useRef<AudioContext | null>(null);
  const currentOscillatorsRef = useRef<OscillatorNode[]>([]);

  const playSound = (index: number) => {
    if (!audioContextRef.current) {
      audioContextRef.current = new AudioContext();
    }

    const ctx = audioContextRef.current;
    const oscillator = ctx.createOscillator();
    const gainNode = ctx.createGain();

    oscillator.connect(gainNode);
    gainNode.connect(ctx.destination);

    // Different frequencies for different number buttons
    const frequencies = [523.25, 587.33, 659.25, 698.46, 783.99, 880.0, 987.77, 1046.5, 1174.66, 1318.51];
    oscillator.frequency.value = frequencies[index];
    oscillator.type = "square";

    gainNode.gain.setValueAtTime(0.2, ctx.currentTime);
    gainNode.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.4);

    oscillator.start(ctx.currentTime);
    oscillator.stop(ctx.currentTime + 0.4);
  };

  const playSpecialSound = (type: string) => {
    // Stop any currently playing special sounds
    currentOscillatorsRef.current.forEach(osc => {
      try {
        osc.stop();
      } catch (e) {
        // Ignore if already stopped
      }
    });
    currentOscillatorsRef.current = [];

    if (!audioContextRef.current) {
      audioContextRef.current = new AudioContext();
    }

    const ctx = audioContextRef.current;

    if (type === "call") {
      // Phone ring melody
      const melody = [
        { freq: 800, time: 0, duration: 0.2 },
        { freq: 1000, time: 0.2, duration: 0.2 },
        { freq: 800, time: 0.5, duration: 0.2 },
        { freq: 1000, time: 0.7, duration: 0.2 },
      ];

      melody.forEach(note => {
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.connect(gain);
        gain.connect(ctx.destination);
        
        osc.frequency.value = note.freq;
        osc.type = "sine";
        
        gain.gain.setValueAtTime(0, ctx.currentTime + note.time);
        gain.gain.linearRampToValueAtTime(0.3, ctx.currentTime + note.time + 0.05);
        gain.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + note.time + note.duration);
        
        osc.start(ctx.currentTime + note.time);
        osc.stop(ctx.currentTime + note.time + note.duration);
        currentOscillatorsRef.current.push(osc);
      });
    } else if (type === "tv") {
      // TV sound effect - swoosh up
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.connect(gain);
      gain.connect(ctx.destination);
      
      osc.frequency.setValueAtTime(200, ctx.currentTime);
      osc.frequency.exponentialRampToValueAtTime(2000, ctx.currentTime + 0.8);
      osc.type = "sawtooth";
      
      gain.gain.setValueAtTime(0.25, ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.8);
      
      osc.start(ctx.currentTime);
      osc.stop(ctx.currentTime + 0.8);
      currentOscillatorsRef.current.push(osc);
    } else if (type === "power") {
      // Power on/off sound - descending
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.connect(gain);
      gain.connect(ctx.destination);
      
      osc.frequency.setValueAtTime(1500, ctx.currentTime);
      osc.frequency.exponentialRampToValueAtTime(100, ctx.currentTime + 1);
      osc.type = "triangle";
      
      gain.gain.setValueAtTime(0.25, ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 1);
      
      osc.start(ctx.currentTime);
      osc.stop(ctx.currentTime + 1);
      currentOscillatorsRef.current.push(osc);
    } else if (type === "star" || type === "hash") {
      // Special button melody
      const melody = [
        { freq: 600, time: 0, duration: 0.15 },
        { freq: 800, time: 0.15, duration: 0.15 },
        { freq: 1000, time: 0.3, duration: 0.3 },
      ];

      melody.forEach(note => {
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.connect(gain);
        gain.connect(ctx.destination);
        
        osc.frequency.value = note.freq;
        osc.type = "square";
        
        gain.gain.setValueAtTime(0.2, ctx.currentTime + note.time);
        gain.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + note.time + note.duration);
        
        osc.start(ctx.currentTime + note.time);
        osc.stop(ctx.currentTime + note.time + note.duration);
        currentOscillatorsRef.current.push(osc);
      });
    }
  };

  const handleButtonPress = (id: string, index: number, type: "number" | "special" = "number") => {
    setActiveButton(id);
    
    if (type === "number") {
      playSound(index);
      setTimeout(() => setActiveButton((prev) => prev === id ? null : prev), 400);
    } else {
      playSpecialSound(id);
      setTimeout(() => setActiveButton((prev) => prev === id ? null : prev), 1000);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-400 via-cyan-400 to-teal-400 flex items-center justify-center p-4">
      <div className="bg-gradient-to-b from-blue-300 to-cyan-300 rounded-[3rem] p-5 shadow-2xl border-8 border-white max-w-lg w-full">
        {/* Top special buttons */}
        <div className="grid grid-cols-3 gap-3 mb-5">
          {SPECIAL_BUTTONS.map((button, index) => (
            <motion.button
              key={button.id}
              onPointerDown={(e) => {
                if (e.pointerType === 'mouse' && e.button !== 0) return;
                handleButtonPress(button.id, index, "special");
              }}
              className={`${button.color} rounded-2xl h-20 flex items-center justify-center shadow-lg border-4 border-white relative overflow-hidden ${
                activeButton === button.id ? "brightness-125 scale-95" : ""
              }`}
              whileTap={{ scale: 0.9 }}
            >
              <div className="text-4xl">{button.emoji}</div>
              
              {activeButton === button.id && (
                <motion.div
                  initial={{ scale: 0, opacity: 1 }}
                  animate={{ scale: 3, opacity: 0 }}
                  transition={{ duration: 0.5 }}
                  className="absolute inset-0 bg-white rounded-2xl"
                />
              )}
            </motion.button>
          ))}
        </div>

        {/* Number pad */}
        <div className="bg-gradient-to-br from-blue-100 to-cyan-100 rounded-3xl p-5 shadow-inner">
          <div className="grid grid-cols-3 gap-4">
            {BUTTONS.map((button, index) => (
              <motion.button
                key={button.num}
                onPointerDown={(e) => {
                  if (e.pointerType === 'mouse' && e.button !== 0) return;
                  handleButtonPress(`num-${button.num}`, index, "number");
                }}
                className={`${button.color} rounded-2xl aspect-square flex flex-col items-center justify-center shadow-xl border-6 border-white relative overflow-hidden ${
                  activeButton === `num-${button.num}` ? "brightness-125 scale-95" : ""
                }`}
                whileTap={{ scale: 0.9 }}
              >
                <div className="text-gray-700 text-8xl font-bold drop-shadow">
                  {button.num}
                </div>

                {activeButton === `num-${button.num}` && (
                  <motion.div
                    initial={{ scale: 0, y: 0 }}
                    animate={{ scale: 2.5, y: -120 }}
                    transition={{ duration: 0.6 }}
                    className="absolute text-7xl"
                  >
                    {button.sound}
                  </motion.div>
                )}
              </motion.button>
            ))}
          </div>

          {/* Bottom special buttons */}
          <div className="grid grid-cols-3 gap-4 mt-4">
            <motion.button
              onPointerDown={(e) => {
                if (e.pointerType === 'mouse' && e.button !== 0) return;
                handleButtonPress("star", 0, "special");
              }}
              className={`bg-gradient-to-br from-yellow-200 to-yellow-300 rounded-2xl h-20 flex items-center justify-center shadow-xl border-4 border-white relative overflow-hidden ${
                activeButton === "star" ? "brightness-125 scale-95" : ""
              }`}
              whileTap={{ scale: 0.9 }}
            >
              <div className="text-gray-600 text-6xl font-bold">*</div>
              {activeButton === "star" && (
                <motion.div
                  initial={{ scale: 0, opacity: 1 }}
                  animate={{ scale: 3, opacity: 0 }}
                  transition={{ duration: 0.5 }}
                  className="absolute inset-0 bg-white rounded-2xl"
                />
              )}
            </motion.button>
            
            <div className="col-span-1"></div>
            
            <motion.button
              onPointerDown={(e) => {
                if (e.pointerType === 'mouse' && e.button !== 0) return;
                handleButtonPress("hash", 1, "special");
              }}
              className={`bg-gradient-to-br from-yellow-200 to-yellow-300 rounded-2xl h-20 flex items-center justify-center shadow-xl border-4 border-white relative overflow-hidden ${
                activeButton === "hash" ? "brightness-125 scale-95" : ""
              }`}
              whileTap={{ scale: 0.9 }}
            >
              <div className="text-gray-600 text-6xl font-bold">#</div>
              {activeButton === "hash" && (
                <motion.div
                  initial={{ scale: 0, opacity: 1 }}
                  animate={{ scale: 3, opacity: 0 }}
                  transition={{ duration: 0.5 }}
                  className="absolute inset-0 bg-white rounded-2xl"
                />
              )}
            </motion.button>
          </div>
        </div>
      </div>

      <HomeButton />
    </div>
  );
}

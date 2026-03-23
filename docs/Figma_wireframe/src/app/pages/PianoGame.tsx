import { useState, useRef, useEffect } from "react";
import { motion } from "motion/react";
import { HomeButton } from "../components/HomeButton";

const WHITE_KEYS = [
  { note: "ド", sound: 261.63, position: 0 },
  { note: "レ", sound: 293.66, position: 1 },
  { note: "ミ", sound: 329.63, position: 2 },
  { note: "ファ", sound: 349.23, position: 3 },
  { note: "ソ", sound: 392.0, position: 4 },
  { note: "ラ", sound: 440.0, position: 5 },
  { note: "シ", sound: 493.88, position: 6 },
  { note: "ド", sound: 523.25, position: 7 },
];

const BLACK_KEYS = [
  { note: "ド#", sound: 277.18, position: 0.65 },
  { note: "レ#", sound: 311.13, position: 1.65 },
  { note: "ファ#", sound: 369.99, position: 3.65 },
  { note: "ソ#", sound: 415.30, position: 4.65 },
  { note: "ラ#", sound: 466.16, position: 5.65 },
];

export function PianoGame() {
  const [activeKeys, setActiveKeys] = useState<Set<string>>(new Set());
  const audioContextRef = useRef<AudioContext | null>(null);

  // AudioContextを事前に初期化して遅延を最小化
  useEffect(() => {
    const initAudio = () => {
      if (!audioContextRef.current) {
        audioContextRef.current = new AudioContext();
      }
    };

    // ユーザーインタラクション時にAudioContextを初期化
    document.addEventListener('touchstart', initAudio, { once: true });
    document.addEventListener('click', initAudio, { once: true });

    return () => {
      document.removeEventListener('touchstart', initAudio);
      document.removeEventListener('click', initAudio);
    };
  }, []);

  const playSound = (frequency: number) => {
    if (!audioContextRef.current) {
      audioContextRef.current = new AudioContext();
    }

    const ctx = audioContextRef.current;
    
    // Resume context if suspended (iOS対策)
    if (ctx.state === 'suspended') {
      ctx.resume();
    }

    const oscillator = ctx.createOscillator();
    const gainNode = ctx.createGain();

    oscillator.connect(gainNode);
    gainNode.connect(ctx.destination);

    oscillator.frequency.value = frequency;
    oscillator.type = "sine";

    // すぐに音を鳴らす（複数同時になっても音が割れないよう音量を少し下げています）
    const now = ctx.currentTime;
    gainNode.gain.setValueAtTime(0.15, now);
    gainNode.gain.exponentialRampToValueAtTime(0.01, now + 0.8);

    oscillator.start(now);
    oscillator.stop(now + 0.8);
  };

  const handleKeyPress = (note: string, frequency: number) => {
    // 音を即座に再生
    playSound(frequency);
    
    setActiveKeys((prev) => new Set(prev).add(note));

    setTimeout(() => {
      setActiveKeys((prev) => {
        const newSet = new Set(prev);
        newSet.delete(note);
        return newSet;
      });
    }, 300);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-sky-200 via-blue-200 to-purple-200 flex items-center justify-center p-6 overflow-hidden relative">
      {/* 装飾的な音符 - 左側 */}
      <motion.div
        animate={{ x: [0, -10, 0], rotate: [-90, -80, -90] }}
        transition={{ duration: 2.5, repeat: Infinity }}
        className="absolute top-[15%] left-2 text-4xl z-0"
      >
        🎵
      </motion.div>
      <motion.div
        animate={{ x: [0, -15, 0], rotate: [-90, -105, -90] }}
        transition={{ duration: 3, repeat: Infinity, delay: 0.3 }}
        className="absolute top-[35%] left-4 text-5xl z-0"
      >
        🎶
      </motion.div>
      <motion.div
        animate={{ x: [0, -12, 0], rotate: [-90, -78, -90] }}
        transition={{ duration: 2.8, repeat: Infinity, delay: 0.6 }}
        className="absolute top-[60%] left-1 text-4xl z-0"
      >
        🎵
      </motion.div>
      <motion.div
        animate={{ x: [0, -15, 0], rotate: [-90, -100, -90] }}
        transition={{ duration: 2.6, repeat: Infinity, delay: 0.9 }}
        className="absolute top-[80%] left-3 text-5xl z-0"
      >
        🎶
      </motion.div>

      {/* 装飾的な音符 - 右側 */}
      <motion.div
        animate={{ x: [0, 10, 0], rotate: [-90, -100, -90] }}
        transition={{ duration: 2.5, repeat: Infinity, delay: 0.2 }}
        className="absolute top-[20%] right-2 text-4xl z-0"
      >
        🎶
      </motion.div>
      <motion.div
        animate={{ x: [0, 15, 0], rotate: [-90, -75, -90] }}
        transition={{ duration: 3, repeat: Infinity, delay: 0.5 }}
        className="absolute top-[40%] right-4 text-5xl z-0"
      >
        🎵
      </motion.div>
      <motion.div
        animate={{ x: [0, 12, 0], rotate: [-90, -102, -90] }}
        transition={{ duration: 2.8, repeat: Infinity, delay: 0.8 }}
        className="absolute top-[65%] right-1 text-4xl z-0"
      >
        🎶
      </motion.div>
      <motion.div
        animate={{ x: [0, 15, 0], rotate: [-90, -80, -90] }}
        transition={{ duration: 2.6, repeat: Infinity, delay: 1.1 }}
        className="absolute top-[85%] right-3 text-5xl z-0"
      >
        🎵
      </motion.div>

      {/* 星の装飾 */}
      <motion.div
        animate={{ scale: [1, 1.3, 1], rotate: [0, 180, 360] }}
        transition={{ duration: 4, repeat: Infinity }}
        className="absolute top-4 left-[20%] text-3xl z-0"
      >
        ⭐
      </motion.div>
      <motion.div
        animate={{ scale: [1, 1.2, 1], rotate: [0, -180, -360] }}
        transition={{ duration: 3.5, repeat: Infinity }}
        className="absolute top-6 right-[25%] text-2xl z-0"
      >
        ✨
      </motion.div>
      <motion.div
        animate={{ scale: [1, 1.4, 1], rotate: [0, 180, 360] }}
        transition={{ duration: 4.5, repeat: Infinity, delay: 0.5 }}
        className="absolute bottom-4 left-[30%] text-3xl z-0"
      >
        🌟
      </motion.div>

      {/* ピアノ本体 - 縦配置 */}
      <div className="w-[280px] h-[85vh] max-h-[700px] relative flex items-center justify-center z-20">
        {/* ピアノの木目枠 左側 */}
        <div className="absolute -left-6 top-0 bottom-0 w-8 bg-gradient-to-r from-amber-700 to-amber-800 rounded-l-2xl shadow-xl border-4 border-amber-900"></div>
        
        {/* 白鍵 - 縦に配置 */}
        <div className="absolute left-0 top-0 bottom-0 flex flex-col-reverse gap-[2px] w-full">
          {WHITE_KEYS.map((key) => (
            <motion.button
              key={key.note + key.position}
              onPointerDown={(e) => {
                if (e.pointerType === 'mouse' && e.button !== 0) return;
                e.currentTarget.releasePointerCapture(e.pointerId);
                handleKeyPress(key.note + key.position, key.sound);
              }}
              onPointerEnter={(e) => {
                // If a pointer (finger) is dragged over this key, play the sound too!
                if (e.buttons > 0) {
                  handleKeyPress(key.note + key.position, key.sound);
                }
              }}
              className={`flex-1 rounded-r-3xl border-4 border-gray-500 shadow-2xl transition-all duration-100 relative overflow-hidden ${
                activeKeys.has(key.note + key.position)
                  ? "bg-gradient-to-r from-gray-300 to-gray-400"
                  : "bg-gradient-to-r from-white via-gray-50 to-gray-100"
              }`}
              whileTap={{ scale: 0.98 }}
              style={{
                boxShadow: activeKeys.has(key.note + key.position)
                  ? "inset 12px 0 30px rgba(0,0,0,0.3), 4px 0 10px rgba(0,0,0,0.2)"
                  : "10px 0 25px rgba(0,0,0,0.4), inset 2px 0 0 rgba(255,255,255,0.8)",
                touchAction: 'none',
              }}
            >
              {/* 鍵盤の音階表示 */}
              <div className="absolute right-6 top-1/2 transform -translate-y-1/2 -rotate-90 text-gray-500 text-3xl font-bold">
                {key.note}
              </div>

              {/* タップエフェクト */}
              {activeKeys.has(key.note + key.position) && (
                <>
                  <motion.div
                    initial={{ scale: 0, opacity: 1 }}
                    animate={{ scale: 2.5, opacity: 0 }}
                    transition={{ duration: 0.6 }}
                    className="absolute left-1/3 top-1/2 -translate-x-1/2 -translate-y-1/2 w-24 h-24 rounded-full border-4 border-pink-400"
                  />
                  <motion.div
                    initial={{ x: 0, opacity: 1, scale: 0.5, rotate: -90 }}
                    animate={{ x: 120, opacity: 0, scale: 1.5, rotate: -90 }}
                    transition={{ duration: 0.8 }}
                    className="absolute left-1/3 top-1/2 -translate-x-1/2 -translate-y-1/2 text-6xl"
                  >
                    ♪
                  </motion.div>
                </>
              )}
            </motion.button>
          ))}
        </div>

        {/* 黒鍵 - 縦に配置 */}
        <div className="absolute left-0 top-0 bottom-0 w-[65%] flex flex-col-reverse pointer-events-none">
          {BLACK_KEYS.map((key) => {
            const keyHeight = 100 / 8; // 8 white keys
            const bottomPosition = key.position * keyHeight;
            
            return (
              <motion.button
                key={key.note + key.position}
                onPointerDown={(e) => {
                  if (e.pointerType === 'mouse' && e.button !== 0) return;
                  e.currentTarget.releasePointerCapture(e.pointerId);
                  handleKeyPress(key.note + key.position, key.sound);
                }}
                onPointerEnter={(e) => {
                  if (e.buttons > 0) {
                    handleKeyPress(key.note + key.position, key.sound);
                  }
                }}
                className={`absolute h-[10%] w-full rounded-r-2xl border-4 border-gray-900 shadow-2xl transition-all duration-100 z-20 pointer-events-auto ${
                  activeKeys.has(key.note + key.position)
                    ? "bg-gradient-to-r from-gray-600 to-gray-700"
                    : "bg-gradient-to-r from-gray-800 via-black to-gray-900"
                }`}
                style={{
                  bottom: `${bottomPosition}%`,
                  boxShadow: activeKeys.has(key.note + key.position)
                    ? "inset 10px 0 25px rgba(0,0,0,0.9), 4px 0 10px rgba(0,0,0,0.5)"
                    : "12px 0 30px rgba(0,0,0,0.9), inset 1px 0 0 rgba(255,255,255,0.1)",
                  touchAction: 'none',
                }}
                whileTap={{ scale: 0.95 }}
              >
                {/* タップエフェクト */}
                {activeKeys.has(key.note + key.position) && (
                  <>
                    <motion.div
                      initial={{ scale: 0, opacity: 1 }}
                      animate={{ scale: 2.5, opacity: 0 }}
                      transition={{ duration: 0.6 }}
                      className="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 w-20 h-20 rounded-full border-4 border-yellow-300"
                    />
                    <motion.div
                      initial={{ x: 0, opacity: 1, scale: 0.5, rotate: -90 }}
                      animate={{ x: 100, opacity: 0, scale: 1.5, rotate: -90 }}
                      transition={{ duration: 0.8 }}
                      className="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 text-5xl"
                    >
                      ♫
                    </motion.div>
                  </>
                )}
              </motion.button>
            );
          })}
        </div>

        {/* ピアノの木目枠 右側 */}
        <div className="absolute -right-8 top-0 bottom-0 w-10 bg-gradient-to-r from-amber-800 to-amber-900 rounded-r-2xl shadow-xl border-4 border-amber-950"></div>
      </div>

      <HomeButton />
    </div>
  );
}
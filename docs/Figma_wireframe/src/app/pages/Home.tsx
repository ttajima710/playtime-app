import { useNavigate } from "react-router";
import { motion } from "motion/react";

export function Home() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gradient-to-b from-yellow-300 via-orange-300 to-pink-400 flex flex-col items-center justify-between p-8 py-16 relative overflow-hidden">
      {/* 装飾要素 - 音符 */}
      <motion.div
        animate={{ y: [0, -10, 0], rotate: [-5, 5, -5] }}
        transition={{ duration: 2, repeat: Infinity }}
        className="absolute top-20 left-12 text-6xl"
      >
        🎵
      </motion.div>
      <motion.div
        animate={{ y: [0, -15, 0], rotate: [5, -5, 5] }}
        transition={{ duration: 2.5, repeat: Infinity, delay: 0.3 }}
        className="absolute top-32 left-24 text-5xl"
      >
        🎶
      </motion.div>

      {/* 装飾要素 - 風船 */}
      <motion.div
        animate={{ y: [0, -10, 0] }}
        transition={{ duration: 3, repeat: Infinity }}
        className="absolute top-24 right-12 text-6xl"
      >
        🎈
      </motion.div>
      <motion.div
        animate={{ y: [0, -12, 0] }}
        transition={{ duration: 2.8, repeat: Infinity, delay: 0.5 }}
        className="absolute top-44 right-28 text-5xl"
      >
        🎈
      </motion.div>

      {/* 装飾要素 - 星 */}
      <motion.div
        animate={{ rotate: 360, scale: [1, 1.2, 1] }}
        transition={{ duration: 4, repeat: Infinity }}
        className="absolute top-1/3 right-8 text-5xl"
      >
        ⭐
      </motion.div>
      <motion.div
        animate={{ rotate: -360, scale: [1, 1.3, 1] }}
        transition={{ duration: 3.5, repeat: Infinity }}
        className="absolute top-1/2 right-16 text-4xl"
      >
        ✨
      </motion.div>

      {/* 装飾要素 - シャボン玉 */}
      <motion.div
        animate={{ y: [0, -20, 0], x: [0, 5, 0] }}
        transition={{ duration: 3.5, repeat: Infinity }}
        className="absolute top-2/3 left-8 text-4xl opacity-60"
      >
        🫧
      </motion.div>

      {/* 装飾要素 - 虹 */}
      <motion.div
        animate={{ scale: [1, 1.1, 1] }}
        transition={{ duration: 3, repeat: Infinity }}
        className="absolute bottom-32 left-12 text-6xl"
      >
        🌈
      </motion.div>

      {/* メインキャラクター */}
      <motion.div
        initial={{ scale: 0, rotate: -180 }}
        animate={{ scale: 1, rotate: 0 }}
        transition={{ type: "spring", duration: 1 }}
        className="relative mt-8"
      >
        <div className="w-56 h-56 bg-gradient-to-br from-blue-400 to-blue-500 rounded-full flex items-center justify-center shadow-2xl border-8 border-white relative">
          <div className="text-9xl">🐰</div>
          
          {/* キャラクター周りの装飾 */}
          <motion.div
            animate={{ rotate: 360 }}
            transition={{ duration: 20, repeat: Infinity, ease: "linear" }}
            className="absolute -top-4 -right-4 text-5xl"
          >
            🎨
          </motion.div>
          <motion.div
            animate={{ rotate: -360 }}
            transition={{ duration: 15, repeat: Infinity, ease: "linear" }}
            className="absolute -bottom-4 -left-4 text-5xl"
          >
            🧸
          </motion.div>
          <motion.div
            animate={{ y: [0, -10, 0] }}
            transition={{ duration: 2, repeat: Infinity }}
            className="absolute top-0 left-8 text-4xl"
          >
            🎪
          </motion.div>
        </div>
      </motion.div>

      {/* タイトル */}
      <motion.div
        initial={{ y: 50, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.3 }}
        className="text-center mt-8"
      >
        <h1 className="text-5xl font-bold text-white drop-shadow-lg mb-2" style={{ textShadow: '4px 4px 0px rgba(0,0,0,0.2)' }}>
          たのしい！
        </h1>
        <h2 className="text-6xl font-bold text-white drop-shadow-lg mb-3" style={{ textShadow: '4px 4px 0px rgba(0,0,0,0.2)' }}>
          プレイタイム
        </h2>
        <p className="text-2xl text-white font-bold drop-shadow-lg" style={{ textShadow: '2px 2px 0px rgba(0,0,0,0.2)' }}>
          1-2さいむけ
        </p>
      </motion.div>

      {/* あそぶボタン */}
      <motion.button
        initial={{ scale: 0 }}
        animate={{ scale: 1 }}
        transition={{ delay: 0.5, type: "spring" }}
        whileTap={{ scale: 0.95 }}
        onClick={() => navigate("/select")}
        className="bg-gradient-to-r from-green-400 to-green-500 text-white text-5xl font-bold py-8 px-16 rounded-full shadow-2xl border-8 border-white relative mb-8"
        style={{ textShadow: '3px 3px 0px rgba(0,0,0,0.2)' }}
      >
        <motion.div
          animate={{ scale: [1, 1.05, 1] }}
          transition={{ duration: 1.5, repeat: Infinity }}
        >
          あそぶ
        </motion.div>
        
        {/* ボタン横の星装飾 */}
        <motion.div
          animate={{ rotate: 360, scale: [1, 1.3, 1] }}
          transition={{ duration: 2, repeat: Infinity }}
          className="absolute -right-8 top-1/2 -translate-y-1/2 text-5xl"
        >
          🌟
        </motion.div>
      </motion.button>
    </div>
  );
}
import { useState, useRef } from "react";
import { useNavigate } from "react-router";
import { Home } from "lucide-react";
import { motion } from "motion/react";

export function HomeButton() {
  const navigate = useNavigate();
  const [progress, setProgress] = useState(0);
  const timerRef = useRef<NodeJS.Timeout | null>(null);
  const startTimeRef = useRef<number>(0);

  const handlePressStart = () => {
    startTimeRef.current = Date.now();
    timerRef.current = setInterval(() => {
      const elapsed = Date.now() - startTimeRef.current;
      const newProgress = Math.min((elapsed / 1000) * 100, 100);
      setProgress(newProgress);
      
      if (newProgress >= 100) {
        if (timerRef.current) clearInterval(timerRef.current);
        navigate("/select");
      }
    }, 50);
  };

  const handlePressEnd = () => {
    if (timerRef.current) {
      clearInterval(timerRef.current);
      timerRef.current = null;
    }
    setProgress(0);
  };

  return (
    <motion.button
      onMouseDown={handlePressStart}
      onMouseUp={handlePressEnd}
      onMouseLeave={handlePressEnd}
      onTouchStart={handlePressStart}
      onTouchEnd={handlePressEnd}
      className="fixed top-6 left-6 w-16 h-16 rounded-full bg-white/30 backdrop-blur-sm flex items-center justify-center shadow-lg"
      whileTap={{ scale: 0.9 }}
    >
      <div className="absolute inset-0 rounded-full overflow-hidden">
        <motion.div
          className="absolute bottom-0 left-0 right-0 bg-white/50"
          style={{ height: `${progress}%` }}
          transition={{ duration: 0.05 }}
        />
      </div>
      <Home className="w-8 h-8 text-white relative z-10" strokeWidth={3} />
    </motion.button>
  );
}
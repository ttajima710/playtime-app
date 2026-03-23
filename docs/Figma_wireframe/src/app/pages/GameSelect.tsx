import { useNavigate } from "react-router";
import { motion } from "motion/react";
import { Music, Palette, Smartphone } from "lucide-react";
import { HomeButton } from "../components/HomeButton";

export function GameSelect() {
  const navigate = useNavigate();

  const games = [
    {
      id: "piano",
      icon: Music,
      color: "bg-gradient-to-br from-pink-300 to-pink-400",
      route: "/piano",
      label: "ぴあの",
    },
    {
      id: "drawing",
      icon: Palette,
      color: "bg-gradient-to-br from-yellow-300 to-orange-300",
      route: "/drawing",
      label: "らくがき",
    },
    {
      id: "remote",
      icon: Smartphone,
      color: "bg-gradient-to-br from-blue-300 to-blue-400",
      route: "/remote",
      label: "りもこん",
    },
    {
      id: "coming-soon",
      icon: null,
      color: "bg-gradient-to-br from-purple-200 to-purple-300",
      route: "",
      label: "？？？",
    },
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-cyan-200 via-blue-200 to-purple-200 flex items-center justify-center p-8">
      <div className="grid grid-cols-2 gap-8 w-full max-w-2xl">
        {games.map((game, index) => (
          <motion.button
            key={game.id}
            initial={{ scale: 0, rotate: -180 }}
            animate={{ scale: 1, rotate: 0 }}
            transition={{ delay: index * 0.1, type: "spring" }}
            whileTap={{ scale: 0.9 }}
            onClick={() => game.route && navigate(game.route)}
            disabled={!game.route}
            className={`${game.color} rounded-3xl aspect-square flex flex-col items-center justify-center gap-4 shadow-2xl border-8 border-white ${
              !game.route ? "opacity-50" : ""
            }`}
          >
            {game.icon && (
              <game.icon className="w-1/3 h-1/3 text-white drop-shadow-lg" strokeWidth={3} />
            )}
            {!game.icon && (
              <div className="text-white text-6xl font-bold">?</div>
            )}
            <div className="text-white text-4xl font-bold drop-shadow-lg">
              {game.label}
            </div>
          </motion.button>
        ))}
      </div>
      
      <HomeButton />
    </div>
  );
}
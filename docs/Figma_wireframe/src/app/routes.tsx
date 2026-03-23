import { createBrowserRouter } from "react-router";
import { Home } from "./pages/Home";
import { GameSelect } from "./pages/GameSelect";
import { PianoGame } from "./pages/PianoGame";
import { DrawingGame } from "./pages/DrawingGame";
import { RemoteGame } from "./pages/RemoteGame";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: Home,
  },
  {
    path: "/select",
    Component: GameSelect,
  },
  {
    path: "/piano",
    Component: PianoGame,
  },
  {
    path: "/drawing",
    Component: DrawingGame,
  },
  {
    path: "/remote",
    Component: RemoteGame,
  },
]);

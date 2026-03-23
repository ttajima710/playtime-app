import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/game_select_screen.dart';
import 'screens/piano/piano_screen.dart';
import 'screens/drawing/drawing_screen.dart';
import 'screens/remote/remote_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/select', builder: (_, __) => const GameSelectScreen()),
    GoRoute(path: '/piano', builder: (_, __) => const PianoScreen()),
    GoRoute(path: '/drawing', builder: (_, __) => const DrawingScreen()),
    GoRoute(path: '/remote', builder: (_, __) => const RemoteScreen()),
  ],
);

class PlaytimeApp extends StatelessWidget {
  const PlaytimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '\u{305F}\u{306E}\u{3057}\u{3044}\u{FF01}\u{30D7}\u{30EC}\u{30A4}\u{30BF}\u{30A4}\u{30E0}',
      theme: AppTheme.theme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

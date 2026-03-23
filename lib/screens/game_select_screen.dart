import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/home_button.dart';

class _GameInfo {
  final String id;
  final IconData? icon;
  final String label;
  final String route;
  final Color colorStart;
  final Color colorEnd;
  final bool enabled;

  const _GameInfo({
    required this.id,
    this.icon,
    required this.label,
    required this.route,
    required this.colorStart,
    required this.colorEnd,
    this.enabled = true,
  });
}

class GameSelectScreen extends StatelessWidget {
  const GameSelectScreen({super.key});

  static final List<_GameInfo> _games = [
    const _GameInfo(
      id: 'piano',
      icon: Icons.music_note,
      label: '\u{3074}\u{3042}\u{306E}',
      route: '/piano',
      colorStart: Color(0xFFF8BBD0),
      colorEnd: Color(0xFFF48FB1),
    ),
    const _GameInfo(
      id: 'drawing',
      icon: Icons.palette,
      label: '\u{3089}\u{304F}\u{304C}\u{304D}',
      route: '/drawing',
      colorStart: Color(0xFFFFF176),
      colorEnd: Color(0xFFFFB74D),
    ),
    const _GameInfo(
      id: 'remote',
      icon: Icons.smartphone,
      label: '\u{308A}\u{3082}\u{3053}\u{3093}',
      route: '/remote',
      colorStart: Color(0xFF81D4FA),
      colorEnd: Color(0xFF42A5F5),
    ),
    const _GameInfo(
      id: 'coming-soon',
      icon: null,
      label: '\uFF1F\uFF1F\uFF1F',
      route: '',
      colorStart: Color(0xFFCE93D8),
      colorEnd: Color(0xFFBA68C8),
      enabled: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB2EBF2), // cyan
              Color(0xFFBBDEFB), // blue
              Color(0xFFE1BEE7), // purple
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 32,
                    mainAxisSpacing: 32,
                  ),
                  itemCount: _games.length,
                  itemBuilder: (context, index) {
                    return _GameCard(
                      game: _games[index],
                      index: index,
                    );
                  },
                ),
              ),
            ),
            const HomeButton(),
          ],
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final _GameInfo game;
  final int index;

  const _GameCard({required this.game, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + index * 100),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: GestureDetector(
        onTap: game.enabled ? () => context.go(game.route) : null,
        child: AnimatedOpacity(
          opacity: game.enabled ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 300),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [game.colorStart, game.colorEnd],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (game.icon != null)
                    Icon(
                      game.icon,
                      size: 64,
                      color: Colors.white,
                    )
                  else
                    const Text(
                      '?',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    game.label,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          offset: const Offset(2, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/audio_service.dart';
import '../widgets/floating_decoration.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (_) => AudioService.instance.init(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFDD835), // yellow
                Color(0xFFFFB74D), // orange
                Color(0xFFF48FB1), // pink
              ],
            ),
          ),
          child: Stack(
            children: [
              // Floating decorations
              const FloatingDecoration(
                emoji: '\u{1F3B5}', // music note
                top: 80,
                left: 48,
                fontSize: 48,
                duration: Duration(milliseconds: 2000),
                yAmplitude: 10,
                rotate: true,
                rotateAmount: 0.1,
              ),
              const FloatingDecoration(
                emoji: '\u{1F3B6}', // music notes
                top: 128,
                left: 96,
                fontSize: 40,
                duration: Duration(milliseconds: 2500),
                yAmplitude: 15,
                rotate: true,
                rotateAmount: -0.1,
              ),
              const FloatingDecoration(
                emoji: '\u{1F388}', // balloon
                top: 96,
                right: 48,
                fontSize: 48,
                duration: Duration(milliseconds: 3000),
                yAmplitude: 10,
              ),
              const FloatingDecoration(
                emoji: '\u{1F388}', // balloon
                top: 176,
                right: 112,
                fontSize: 40,
                duration: Duration(milliseconds: 2800),
                yAmplitude: 12,
              ),
              const FloatingDecoration(
                emoji: '\u{2B50}', // star
                top: 200,
                right: 32,
                fontSize: 40,
                duration: Duration(milliseconds: 4000),
                rotate: true,
                rotateAmount: 3.14,
                scale: true,
                scaleMax: 1.2,
              ),
              const FloatingDecoration(
                emoji: '\u{2728}', // sparkles
                top: 300,
                right: 64,
                fontSize: 32,
                duration: Duration(milliseconds: 3500),
                scale: true,
                scaleMax: 1.3,
              ),
              const FloatingDecoration(
                emoji: '\u{1FAE7}', // bubbles
                top: 450,
                left: 32,
                fontSize: 32,
                duration: Duration(milliseconds: 3500),
                yAmplitude: 20,
                xAmplitude: 5,
                opacity: 0.6,
              ),
              const FloatingDecoration(
                emoji: '\u{1F308}', // rainbow
                top: 520,
                left: 48,
                fontSize: 48,
                duration: Duration(milliseconds: 3000),
                scale: true,
                scaleMax: 1.1,
              ),

              // Main content
              SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Main character - Rabbit in blue circle
                      _buildCharacter(),
                      // Title
                      _buildTitle(),
                      // Play button
                      _buildPlayButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacter() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: 224,
              height: 224,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3E8EFE),
                border: Border.all(color: Colors.white, width: 8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Image.asset(
                  'docs/image.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // 装飾アイテム
            const Positioned(
              top: 20, left: 15,
              child: Text('\u{1F3B5}', style: TextStyle(fontSize: 40)),
            ),
            const Positioned(
              top: 55, left: 0,
              child: Text('\u{1F3B6}', style: TextStyle(fontSize: 32)),
            ),
            const Positioned(
              top: 5, left: 85,
              child: Text('\u{1F3AA}', style: TextStyle(fontSize: 32)),
            ),
            const Positioned(
              top: 15, right: 10,
              child: Text('\u{1F3A8}', style: TextStyle(fontSize: 40)),
            ),
            const Positioned(
              bottom: 15, left: 20,
              child: Text('\u{1F9F8}', style: TextStyle(fontSize: 40)),
            ),
            const Positioned(
              bottom: 20, right: 25,
              child: Text('\u{2B50}', style: TextStyle(fontSize: 40)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          Text(
            '\u{305F}\u{306E}\u{3057}\u{3044}\u{FF01}',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  offset: const Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
          Text(
            '\u{30D7}\u{30EC}\u{30A4}\u{30BF}\u{30A4}\u{30E0}',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  offset: const Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '1-2\u{3055}\u{3044}\u{3080}\u{3051}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  offset: const Offset(2, 2),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: _PulsingPlayButton(
        onTap: () => context.go('/select'),
      ),
    );
  }
}

class _PulsingPlayButton extends StatefulWidget {
  final VoidCallback onTap;
  const _PulsingPlayButton({required this.onTap});

  @override
  State<_PulsingPlayButton> createState() => _PulsingPlayButtonState();
}


class _PulsingPlayButtonState extends State<_PulsingPlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1.0 + _controller.value * 0.05;
        return Transform.scale(scale: scale, child: child);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
            ),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white, width: 8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\u{3042}\u{305D}\u{3076}',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      offset: const Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text('\u{1F31F}', style: TextStyle(fontSize: 40)),
            ],
          ),
        ),
      ),
    );
  }
}

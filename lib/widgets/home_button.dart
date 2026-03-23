import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A button in the top-left corner that navigates back to the game select
/// screen when held for 1 second. Shows a circular progress indicator.
class HomeButton extends StatefulWidget {
  const HomeButton({super.key});

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  double _progress = 0.0;
  Timer? _timer;
  DateTime? _startTime;

  void _handlePressStart() {
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_startTime == null) return;
      final elapsed = DateTime.now().difference(_startTime!).inMilliseconds;
      final newProgress = (elapsed / 1000.0).clamp(0.0, 1.0);
      setState(() => _progress = newProgress);

      if (newProgress >= 1.0) {
        _timer?.cancel();
        _timer = null;
        if (mounted) {
          context.go('/select');
        }
      }
    });
  }

  void _handlePressEnd() {
    _timer?.cancel();
    _timer = null;
    _startTime = null;
    setState(() => _progress = 0.0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 24,
      left: 24,
      child: GestureDetector(
        onTapDown: (_) => _handlePressStart(),
        onTapUp: (_) => _handlePressEnd(),
        onTapCancel: _handlePressEnd,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress fill from bottom
              ClipOval(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: _progress,
                  child: Container(
                    width: 64,
                    height: 64,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
              // Home icon
              const Icon(
                Icons.home,
                size: 32,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// A floating decoration widget that animates with a bobbing/rotating motion.
class FloatingDecoration extends StatefulWidget {
  final String emoji;
  final double top;
  final double? left;
  final double? right;
  final double fontSize;
  final Duration duration;
  final double yAmplitude;
  final double? xAmplitude;
  final bool rotate;
  final double rotateAmount;
  final bool scale;
  final double scaleMin;
  final double scaleMax;
  final double opacity;

  const FloatingDecoration({
    super.key,
    required this.emoji,
    required this.top,
    this.left,
    this.right,
    this.fontSize = 48,
    this.duration = const Duration(seconds: 3),
    this.yAmplitude = 10,
    this.xAmplitude,
    this.rotate = false,
    this.rotateAmount = 0.1,
    this.scale = false,
    this.scaleMin = 1.0,
    this.scaleMax = 1.2,
    this.opacity = 1.0,
  });

  @override
  State<FloatingDecoration> createState() => _FloatingDecorationState();
}

class _FloatingDecorationState extends State<FloatingDecoration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
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
        final value = _controller.value;
        final yOffset = (value - 0.5) * 2 * widget.yAmplitude;
        final xOffset = widget.xAmplitude != null
            ? (value - 0.5) * 2 * widget.xAmplitude!
            : 0.0;

        double scaleValue = 1.0;
        if (widget.scale) {
          scaleValue = widget.scaleMin +
              (widget.scaleMax - widget.scaleMin) * value;
        }

        double rotationValue = 0.0;
        if (widget.rotate) {
          rotationValue = (value - 0.5) * 2 * widget.rotateAmount;
        }

        return Positioned(
          top: widget.top + yOffset,
          left: widget.left != null ? widget.left! + xOffset : null,
          right: widget.right != null ? widget.right! - xOffset : null,
          child: Opacity(
            opacity: widget.opacity,
            child: Transform.scale(
              scale: scaleValue,
              child: Transform.rotate(
                angle: rotationValue,
                child: Text(
                  widget.emoji,
                  style: TextStyle(fontSize: widget.fontSize),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

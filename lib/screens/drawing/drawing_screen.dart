import 'dart:math';
import 'package:flutter/material.dart';
import '../../services/audio_service.dart';
import '../../widgets/home_button.dart';

class _DrawPoint {
  final Offset position;
  final Color color;
  final bool isStart;

  _DrawPoint(this.position, this.color, {this.isStart = false});
}

class _StampData {
  final Offset position;
  final IconData icon;
  final DateTime createdAt;

  _StampData(this.position, this.icon) : createdAt = DateTime.now();
}

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final List<_DrawPoint> _points = [];
  final List<_StampData> _stamps = [];
  double _hue = 0;
  bool _isDrawing = false;
  final _audio = AudioService.instance;
  final _random = Random();

  static const _stampIcons = [
    Icons.star,
    Icons.favorite,
    Icons.auto_awesome,
  ];

  void _onPointerDown(PointerEvent event) {
    _audio.init();
    _isDrawing = true;
    _audio.startContinuousTone(frequency: 300);

    final pos = event.localPosition;
    setState(() {
      _points.add(_DrawPoint(pos, _currentColor, isStart: true));
    });
  }

  void _onPointerMove(PointerEvent event) {
    if (!_isDrawing) return;

    _hue = (_hue + 2) % 360;
    _audio.updateFrequency(300 + _hue * 2);

    final pos = event.localPosition;
    setState(() {
      _points.add(_DrawPoint(pos, _currentColor));
    });
  }

  void _onPointerUp(PointerEvent event) {
    if (!_isDrawing) return;
    _isDrawing = false;
    _audio.stopContinuousTone();

    // Play release sound
    _audio.playTone(
      frequency: 400,
      duration: 0.3,
      waveType: 'triangle',
      volume: 0.2,
    );
    // Also play ascending sparkle
    _audio.playSweep(
      startFreq: 400,
      endFreq: 1200,
      duration: 0.3,
      waveType: 'triangle',
      volume: 0.2,
    );

    // Add stamp
    final pos = event.localPosition;
    final icon = _stampIcons[_random.nextInt(_stampIcons.length)];
    setState(() {
      _stamps.add(_StampData(pos, icon));
    });
  }

  Color get _currentColor =>
      HSLColor.fromAHSL(1.0, _hue, 0.8, 0.6).toColor();

  void _clearCanvas() {
    // Play trash sound
    _audio.playSweep(
      startFreq: 200,
      endFreq: 50,
      duration: 0.3,
      waveType: 'sawtooth',
      volume: 0.2,
    );
    setState(() {
      _points.clear();
      _stamps.clear();
    });
  }

  @override
  void dispose() {
    _audio.stopContinuousTone();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Drawing canvas
          Listener(
            onPointerDown: _onPointerDown,
            onPointerMove: _onPointerMove,
            onPointerUp: _onPointerUp,
            child: Container(
              color: Colors.white,
              child: CustomPaint(
                painter: _DrawingPainter(_points),
                size: Size.infinite,
              ),
            ),
          ),

          // Stamps
          ..._stamps.map((stamp) => _AnimatedStamp(stamp: stamp)),

          // Trash button (long press to clear)
          Positioned(
            bottom: 32,
            right: 32,
            child: GestureDetector(
              onLongPress: _clearCanvas,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEF5350),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delete,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const HomeButton(),
        ],
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<_DrawPoint> points;

  _DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length; i++) {
      if (points[i].isStart || i == 0) continue;
      if (points[i - 1].isStart && i > 0) {
        // This is the start of a new stroke, draw from previous if not start
      }

      final paint = Paint()
        ..color = points[i].color
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (!points[i].isStart && i > 0 && !points[i - 1].isStart) {
        canvas.drawLine(
          points[i - 1].position,
          points[i].position,
          paint,
        );
      } else if (points[i].isStart) {
        // Draw a dot at the start
        final dotPaint = Paint()
          ..color = points[i].color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(points[i].position, 10, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}

class _AnimatedStamp extends StatefulWidget {
  final _StampData stamp;

  const _AnimatedStamp({required this.stamp});

  @override
  State<_AnimatedStamp> createState() => _AnimatedStampState();
}

class _AnimatedStampState extends State<_AnimatedStamp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.stamp.position.dx - 24,
      top: widget.stamp.position.dy - 24,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: child,
            ),
          );
        },
        child: Icon(
          widget.stamp.icon,
          size: 48,
          color: const Color(0xFFFDD835),
          shadows: const [
            Shadow(
              color: Color(0x40000000),
              blurRadius: 4,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
    );
  }
}

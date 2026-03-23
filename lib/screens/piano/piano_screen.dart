import 'package:flutter/material.dart';
import '../../services/audio_service.dart';
import '../../widgets/home_button.dart';
import '../../widgets/floating_decoration.dart';

class _KeyInfo {
  final String note;
  final double frequency;
  final int position;

  const _KeyInfo(this.note, this.frequency, this.position);
}

class _BlackKeyInfo {
  final String note;
  final double frequency;
  final double position;

  const _BlackKeyInfo(this.note, this.frequency, this.position);
}

const _whiteKeys = [
  _KeyInfo('\u{30C9}', 261.63, 0), // Do
  _KeyInfo('\u{30EC}', 293.66, 1), // Re
  _KeyInfo('\u{30DF}', 329.63, 2), // Mi
  _KeyInfo('\u{30D5}\u{30A1}', 349.23, 3), // Fa
  _KeyInfo('\u{30BD}', 392.0, 4), // So
  _KeyInfo('\u{30E9}', 440.0, 5), // La
  _KeyInfo('\u{30B7}', 493.88, 6), // Si
  _KeyInfo('\u{30C9}', 523.25, 7), // Do (high)
];

const _blackKeys = [
  _BlackKeyInfo('\u{30C9}#', 277.18, 0.65),
  _BlackKeyInfo('\u{30EC}#', 311.13, 1.65),
  _BlackKeyInfo('\u{30D5}\u{30A1}#', 369.99, 3.65),
  _BlackKeyInfo('\u{30BD}#', 415.30, 4.65),
  _BlackKeyInfo('\u{30E9}#', 466.16, 5.65),
];

class PianoScreen extends StatefulWidget {
  const PianoScreen({super.key});

  @override
  State<PianoScreen> createState() => _PianoScreenState();
}

class _PianoScreenState extends State<PianoScreen> {
  final Set<String> _activeKeys = {};
  final _audio = AudioService.instance;

  void _playKey(String keyId, double frequency) {
    _audio.playTone(frequency: frequency, duration: 0.8, waveType: 'sine');
    setState(() => _activeKeys.add(keyId));
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _activeKeys.remove(keyId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB3E5FC), // sky blue
              Color(0xFFBBDEFB), // blue
              Color(0xFFE1BEE7), // purple
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating music notes - left side
            const FloatingDecoration(
              emoji: '\u{1F3B5}',
              top: 60,
              left: 8,
              fontSize: 32,
              duration: Duration(milliseconds: 2500),
              xAmplitude: -10,
              rotate: true,
            ),
            const FloatingDecoration(
              emoji: '\u{1F3B6}',
              top: 200,
              left: 16,
              fontSize: 40,
              duration: Duration(milliseconds: 3000),
              xAmplitude: -15,
            ),
            const FloatingDecoration(
              emoji: '\u{1F3B5}',
              top: 400,
              left: 4,
              fontSize: 32,
              duration: Duration(milliseconds: 2800),
              xAmplitude: -12,
            ),
            // Right side
            const FloatingDecoration(
              emoji: '\u{1F3B6}',
              top: 100,
              right: 8,
              fontSize: 32,
              duration: Duration(milliseconds: 2500),
              xAmplitude: 10,
            ),
            const FloatingDecoration(
              emoji: '\u{1F3B5}',
              top: 280,
              right: 16,
              fontSize: 40,
              duration: Duration(milliseconds: 3000),
              xAmplitude: 15,
            ),
            // Stars
            const FloatingDecoration(
              emoji: '\u{2B50}',
              top: 16,
              left: 80,
              fontSize: 24,
              duration: Duration(milliseconds: 4000),
              rotate: true,
              rotateAmount: 3.14,
              scale: true,
              scaleMax: 1.3,
            ),
            const FloatingDecoration(
              emoji: '\u{2728}',
              top: 24,
              right: 100,
              fontSize: 20,
              duration: Duration(milliseconds: 3500),
              scale: true,
              scaleMax: 1.2,
            ),
            const FloatingDecoration(
              emoji: '\u{1F31F}',
              top: 600,
              left: 120,
              fontSize: 24,
              duration: Duration(milliseconds: 4500),
              rotate: true,
              rotateAmount: 3.14,
              scale: true,
              scaleMax: 1.4,
            ),

            // Piano body - centered
            Center(
              child: _buildPiano(context),
            ),

            const HomeButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPiano(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final pianoHeight = screenHeight * 0.85;
    const pianoWidth = 280.0;

    return SizedBox(
      width: pianoWidth + 40, // extra for wood frame
      height: pianoHeight,
      child: Stack(
        children: [
          // Left wood frame
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8D6E63), Color(0xFF6D4C41)],
                ),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
                border: Border.all(color: const Color(0xFF4E342E), width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),

          // White keys
          Positioned(
            left: 24,
            top: 0,
            bottom: 0,
            width: pianoWidth,
            child: Column(
              children: _whiteKeys.reversed.map((key) {
                final keyId = '${key.note}${key.position}';
                final isActive = _activeKeys.contains(keyId);
                return Expanded(
                  child: Listener(
                    onPointerDown: (_) => _playKey(keyId, key.frequency),
                    child: _WhiteKey(
                      note: key.note,
                      isActive: isActive,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Black keys
          Positioned(
            left: 24,
            top: 0,
            bottom: 0,
            width: pianoWidth * 0.65,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final keyHeight = constraints.maxHeight / 8;
                return Stack(
                  children: _blackKeys.map((key) {
                    final keyId = '${key.note}${key.position}';
                    final isActive = _activeKeys.contains(keyId);
                    final bottomPos = key.position * keyHeight;
                    return Positioned(
                      bottom: bottomPos,
                      left: 0,
                      right: 0,
                      height: keyHeight * 0.7,
                      child: Listener(
                        onPointerDown: (_) => _playKey(keyId, key.frequency),
                        child: _BlackKey(isActive: isActive),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),

          // Right wood frame
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6D4C41), Color(0xFF5D4037)],
                ),
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(16),
                ),
                border: Border.all(color: const Color(0xFF3E2723), width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WhiteKey extends StatelessWidget {
  final String note;
  final bool isActive;

  const _WhiteKey({required this.note, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isActive
              ? [const Color(0xFFBDBDBD), const Color(0xFF9E9E9E)]
              : [Colors.white, const Color(0xFFF5F5F5), const Color(0xFFE0E0E0)],
        ),
        borderRadius: const BorderRadius.horizontal(
          right: Radius.circular(12),
        ),
        border: Border.all(color: const Color(0xFF757575), width: 2),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(4, 0),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(8, 0),
                ),
              ],
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 24),
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              note,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BlackKey extends StatelessWidget {
  final bool isActive;

  const _BlackKey({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isActive
              ? [const Color(0xFF616161), const Color(0xFF424242)]
              : [const Color(0xFF212121), Colors.black, const Color(0xFF212121)],
        ),
        borderRadius: const BorderRadius.horizontal(
          right: Radius.circular(8),
        ),
        border: Border.all(color: const Color(0xFF212121), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isActive ? 0.5 : 0.9),
            blurRadius: isActive ? 8 : 16,
            offset: const Offset(8, 0),
          ),
        ],
      ),
    );
  }
}

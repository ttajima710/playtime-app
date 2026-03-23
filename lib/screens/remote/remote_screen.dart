import 'package:flutter/material.dart';
import '../../services/audio_service.dart';
import '../../widgets/home_button.dart';

class _NumberButton {
  final int num;
  final Color colorStart;
  final Color colorEnd;
  final String animalEmoji;

  const _NumberButton(this.num, this.colorStart, this.colorEnd, this.animalEmoji);
}

class _SpecialButton {
  final String id;
  final String emoji;
  final Color colorStart;
  final Color colorEnd;

  const _SpecialButton(this.id, this.emoji, this.colorStart, this.colorEnd);
}

const _numberButtons = [
  _NumberButton(1, Color(0xFF81D4FA), Color(0xFF42A5F5), '\u{1F436}'), // dog
  _NumberButton(2, Color(0xFFA5D6A7), Color(0xFF66BB6A), '\u{1F431}'), // cat
  _NumberButton(3, Color(0xFFFFF176), Color(0xFFFDD835), '\u{1F697}'), // car
  _NumberButton(4, Color(0xFFF8BBD0), Color(0xFFF48FB1), '\u{1F3B5}'), // music
  _NumberButton(5, Color(0xFFCE93D8), Color(0xFFAB47BC), '\u{1F514}'), // bell
  _NumberButton(6, Color(0xFFEF9A9A), Color(0xFFEF5350), '\u{1F42E}'), // cow
  _NumberButton(7, Color(0xFFFFCC80), Color(0xFFFF9800), '\u{1F682}'), // train
  _NumberButton(8, Color(0xFF80CBC4), Color(0xFF26A69A), '\u{1F438}'), // frog
  _NumberButton(9, Color(0xFF9FA8DA), Color(0xFF5C6BC0), '\u{1F986}'), // duck
  _NumberButton(0, Color(0xFF80DEEA), Color(0xFF00BCD4), '\u{1F437}'), // pig
];

const _specialButtons = [
  _SpecialButton('call', '\u{1F4DE}', Color(0xFFFF9800), Color(0xFFF57C00)),
  _SpecialButton('tv', '\u{1F4FA}', Color(0xFF42A5F5), Color(0xFF1E88E5)),
  _SpecialButton('power', '\u{26A1}', Color(0xFFEF5350), Color(0xFFE53935)),
];

const _numberFrequencies = [
  523.25, 587.33, 659.25, 698.46, 783.99,
  880.0, 987.77, 1046.5, 1174.66, 1318.51,
];

class RemoteScreen extends StatefulWidget {
  const RemoteScreen({super.key});

  @override
  State<RemoteScreen> createState() => _RemoteScreenState();
}

class _RemoteScreenState extends State<RemoteScreen> {
  String? _activeButton;
  final _audio = AudioService.instance;

  void _playNumberSound(int index) {
    _audio.playTone(
      frequency: _numberFrequencies[index],
      duration: 0.4,
      waveType: 'square',
      volume: 0.2,
    );
  }

  void _playSpecialSound(String type) {
    switch (type) {
      case 'call':
        _audio.playMelody([
          const MelodyNote(frequency: 800, startTime: 0, duration: 0.2),
          const MelodyNote(frequency: 1000, startTime: 0.2, duration: 0.2),
          const MelodyNote(frequency: 800, startTime: 0.5, duration: 0.2),
          const MelodyNote(frequency: 1000, startTime: 0.7, duration: 0.2),
        ]);
        break;
      case 'tv':
        _audio.playSweep(
          startFreq: 200,
          endFreq: 2000,
          duration: 0.8,
          waveType: 'sawtooth',
          volume: 0.25,
        );
        break;
      case 'power':
        _audio.playSweep(
          startFreq: 1500,
          endFreq: 100,
          duration: 1.0,
          waveType: 'triangle',
          volume: 0.25,
        );
        break;
      case 'star':
      case 'hash':
        _audio.playMelody([
          const MelodyNote(
              frequency: 600, startTime: 0, duration: 0.15, waveType: 'square'),
          const MelodyNote(
              frequency: 800, startTime: 0.15, duration: 0.15, waveType: 'square'),
          const MelodyNote(
              frequency: 1000, startTime: 0.3, duration: 0.3, waveType: 'square'),
        ]);
        break;
    }
  }

  void _handleNumberPress(int num, int index) {
    final id = 'num-$num';
    setState(() => _activeButton = id);
    _playNumberSound(index);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted && _activeButton == id) {
        setState(() => _activeButton = null);
      }
    });
  }

  void _handleSpecialPress(String id) {
    setState(() => _activeButton = id);
    _playSpecialSound(id);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted && _activeButton == id) {
        setState(() => _activeButton = null);
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
              Color(0xFF42A5F5),
              Color(0xFF00BCD4),
              Color(0xFF26A69A),
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF81D4FA), Color(0xFF4DD0E1)],
                  ),
                  borderRadius: BorderRadius.circular(48),
                  border: Border.all(color: Colors.white, width: 8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Special buttons row
                    Row(
                      children: _specialButtons.map((btn) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: _RemoteSpecialButton(
                              button: btn,
                              isActive: _activeButton == btn.id,
                              onPressed: () => _handleSpecialPress(btn.id),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Number pad
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFE1F5FE), Color(0xFFE0F7FA)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Numbers 1-9 in 3x3 grid
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              final btn = _numberButtons[index];
                              return _RemoteNumberButton(
                                button: btn,
                                isActive: _activeButton == 'num-${btn.num}',
                                onPressed: () =>
                                    _handleNumberPress(btn.num, index),
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          // Bottom row: * 0 #
                          Row(
                            children: [
                              Expanded(
                                child: _StarHashButton(
                                  label: '*',
                                  isActive: _activeButton == 'star',
                                  onPressed: () => _handleSpecialPress('star'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _RemoteNumberButton(
                                  button: _numberButtons[9], // 0
                                  isActive: _activeButton == 'num-0',
                                  onPressed: () => _handleNumberPress(0, 9),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StarHashButton(
                                  label: '#',
                                  isActive: _activeButton == 'hash',
                                  onPressed: () => _handleSpecialPress('hash'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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

class _RemoteNumberButton extends StatelessWidget {
  final _NumberButton button;
  final bool isActive;
  final VoidCallback onPressed;

  const _RemoteNumberButton({
    required this.button,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => onPressed(),
      child: AnimatedScale(
        scale: isActive ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [button.colorStart, button.colorEnd],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '${button.num}',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  shadows: [
                    Shadow(
                      color: Colors.white.withValues(alpha: 0.5),
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              // Animal emoji flies up when active
              if (isActive)
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, -120 * value),
                      child: Opacity(
                        opacity: 1 - value,
                        child: Transform.scale(
                          scale: 1 + value,
                          child: Text(
                            button.animalEmoji,
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RemoteSpecialButton extends StatelessWidget {
  final _SpecialButton button;
  final bool isActive;
  final VoidCallback onPressed;

  const _RemoteSpecialButton({
    required this.button,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => onPressed(),
      child: AnimatedScale(
        scale: isActive ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [button.colorStart, button.colorEnd],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              button.emoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
      ),
    );
  }
}

class _StarHashButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const _StarHashButton({
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => onPressed(),
      child: AnimatedScale(
        scale: isActive ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF9C4), Color(0xFFFFF176)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

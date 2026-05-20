import 'package:web/web.dart' as web;

/// Web Audio API wrapper for low-latency sound generation.
/// Uses dart:js_interop to directly control browser AudioContext.
class AudioService {
  static AudioService? _instance;
  web.AudioContext? _audioContext;

  // Continuous tone refs (for drawing game)
  web.OscillatorNode? _continuousOscillator;
  web.GainNode? _continuousGain;

  AudioService._();

  static AudioService get instance {
    _instance ??= AudioService._();
    return _instance!;
  }

  /// Initialize AudioContext. Must be called from a user gesture (tap/click).
  void init() {
    _audioContext ??= web.AudioContext();
    if (_audioContext!.state == 'suspended') {
      _audioContext!.resume();
    }
  }

  /// Ensure AudioContext is ready.
  web.AudioContext _getContext() {
    _audioContext ??= web.AudioContext();
    if (_audioContext!.state == 'suspended') {
      _audioContext!.resume();
    }
    return _audioContext!;
  }

  /// Play a single tone.
  /// [frequency] in Hz, [duration] in seconds, [waveType] is 'sine', 'square', 'triangle', 'sawtooth'.
  /// [volume] is 0.0 to 1.0.
  void playTone({
    required double frequency,
    double duration = 0.8,
    String waveType = 'sine',
    double volume = 0.15,
  }) {
    final ctx = _getContext();
    final oscillator = ctx.createOscillator();
    final gainNode = ctx.createGain();

    oscillator.connect(gainNode);
    gainNode.connect(ctx.destination);

    oscillator.type = waveType;
    oscillator.frequency.value = frequency;

    final now = ctx.currentTime;
    gainNode.gain.setValueAtTime(volume, now);
    gainNode.gain.exponentialRampToValueAtTime(0.01, now + duration);

    oscillator.start(now);
    oscillator.stop(now + duration);
  }

  /// Play a frequency sweep (e.g., for TV or power sounds).
  void playSweep({
    required double startFreq,
    required double endFreq,
    double duration = 0.8,
    String waveType = 'sawtooth',
    double volume = 0.25,
  }) {
    final ctx = _getContext();
    final oscillator = ctx.createOscillator();
    final gainNode = ctx.createGain();

    oscillator.connect(gainNode);
    gainNode.connect(ctx.destination);

    oscillator.type = waveType;
    final now = ctx.currentTime;
    oscillator.frequency.setValueAtTime(startFreq, now);
    oscillator.frequency.exponentialRampToValueAtTime(endFreq, now + duration);

    gainNode.gain.setValueAtTime(volume, now);
    gainNode.gain.exponentialRampToValueAtTime(0.01, now + duration);

    oscillator.start(now);
    oscillator.stop(now + duration);
  }

  /// Play a melody sequence (list of notes with timing).
  void playMelody(List<MelodyNote> notes) {
    final ctx = _getContext();
    for (final note in notes) {
      final oscillator = ctx.createOscillator();
      final gainNode = ctx.createGain();

      oscillator.connect(gainNode);
      gainNode.connect(ctx.destination);

      oscillator.type = note.waveType;
      oscillator.frequency.value = note.frequency;

      final now = ctx.currentTime;
      final start = now + note.startTime;
      gainNode.gain.setValueAtTime(0.0, start);
      gainNode.gain.linearRampToValueAtTime(note.volume, start + 0.05);
      gainNode.gain.exponentialRampToValueAtTime(0.01, start + note.duration);

      oscillator.start(start);
      oscillator.stop(start + note.duration);
    }
  }

  /// Start a continuous tone (for drawing sound).
  void startContinuousTone({
    double frequency = 300,
    String waveType = 'sine',
    double volume = 0.1,
  }) {
    stopContinuousTone();

    final ctx = _getContext();
    _continuousOscillator = ctx.createOscillator();
    _continuousGain = ctx.createGain();

    _continuousOscillator!.connect(_continuousGain!);
    _continuousGain!.connect(ctx.destination);

    _continuousOscillator!.type = waveType;
    _continuousOscillator!.frequency.value = frequency;
    _continuousGain!.gain.value = volume;

    _continuousOscillator!.start();
  }

  /// Update frequency of the continuous tone.
  void updateFrequency(double frequency) {
    if (_continuousOscillator != null && _audioContext != null) {
      _continuousOscillator!.frequency.setTargetAtTime(
        frequency,
        _audioContext!.currentTime,
        0.05,
      );
    }
  }

  /// Stop the continuous tone.
  void stopContinuousTone() {
    if (_continuousOscillator != null) {
      try {
        _continuousOscillator!.stop();
      } catch (_) {}
      _continuousOscillator!.disconnect();
      _continuousOscillator = null;
    }
    if (_continuousGain != null) {
      _continuousGain!.disconnect();
      _continuousGain = null;
    }
  }
}

/// Represents a single note in a melody sequence.
class MelodyNote {
  final double frequency;
  final double startTime;
  final double duration;
  final double volume;
  final String waveType;

  const MelodyNote({
    required this.frequency,
    required this.startTime,
    required this.duration,
    this.volume = 0.3,
    this.waveType = 'sine',
  });
}

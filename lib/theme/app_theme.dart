import 'package:flutter/material.dart';

class AppTheme {
  // Pastel color palette
  static const Color pastelPink = Color(0xFFFFC1CC);
  static const Color pastelYellow = Color(0xFFFFE5A0);
  static const Color pastelBlue = Color(0xFFB3E5FC);
  static const Color pastelGreen = Color(0xFFB8F5B0);
  static const Color pastelPurple = Color(0xFFE1BEE7);
  static const Color pastelOrange = Color(0xFFFFCC80);
  static const Color pastelCyan = Color(0xFFB2EBF2);

  // Game card colors
  static const Color pianoCardStart = Color(0xFFF8BBD0);
  static const Color pianoCardEnd = Color(0xFFF48FB1);
  static const Color drawingCardStart = Color(0xFFFFF176);
  static const Color drawingCardEnd = Color(0xFFFFB74D);
  static const Color remoteCardStart = Color(0xFF81D4FA);
  static const Color remoteCardEnd = Color(0xFF42A5F5);
  static const Color comingSoonCardStart = Color(0xFFCE93D8);
  static const Color comingSoonCardEnd = Color(0xFFBA68C8);

  // Play button
  static const Color playButtonStart = Color(0xFF66BB6A);
  static const Color playButtonEnd = Color(0xFF43A047);

  static ThemeData get theme => ThemeData(
        fontFamily: 'sans-serif',
        colorScheme: ColorScheme.fromSeed(
          seedColor: pastelPink,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      );
}

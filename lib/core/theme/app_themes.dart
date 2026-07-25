import 'package:flutter/material.dart';

class MapThemeData {
  final Color background;
  final Color countryFill;
  final Color countryBorder;
  final Color highlightFill;
  final Color correctFill;
  final Color incorrectFill;
  final Color waterColor;
  final Color riverColor;
  final Color capitalMarker;

  const MapThemeData({
    required this.background,
    required this.countryFill,
    required this.countryBorder,
    required this.highlightFill,
    required this.correctFill,
    required this.incorrectFill,
    required this.waterColor,
    required this.riverColor,
    required this.capitalMarker,
  });
}

class AppThemes {
  static const dark = MapThemeData(
    background: Color(0xFF0F172A),
    countryFill: Color(0xFF334155),
    countryBorder: Color(0xFF64748B),
    highlightFill: Color(0xFFF59E0B),
    correctFill: Color(0xFF10B981),
    incorrectFill: Color(0xFFEF4444),
    waterColor: Color(0xFF1E293B),
    riverColor: Color(0xFF38BDF8),
    capitalMarker: Color(0xFFF8FAFC),
  );

  static const light = MapThemeData(
    background: Color(0xFFF8FAFC),
    countryFill: Color(0xFFE2E8F0),
    countryBorder: Color(0xFFCBD5E1),
    highlightFill: Color(0xFFF59E0B),
    correctFill: Color(0xFF10B981),
    incorrectFill: Color(0xFFEF4444),
    waterColor: Color(0xFFDBEAFE),
    riverColor: Color(0xFF3B82F6),
    capitalMarker: Color(0xFF1E293B),
  );

  static const parchment = MapThemeData(
    background: Color(0xFFF4E4BC),
    countryFill: Color(0xFFD2B48C),
    countryBorder: Color(0xFF8B7355),
    highlightFill: Color(0xFFD97706),
    correctFill: Color(0xFF059669),
    incorrectFill: Color(0xFFDC2626),
    waterColor: Color(0xFFC8D8E4),
    riverColor: Color(0xFF4A90A4),
    capitalMarker: Color(0xFF433422),
  );

  static ThemeData materialDark() => ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF38BDF8),
          brightness: Brightness.dark,
          surface: const Color(0xFF0F172A),
        ),
        scaffoldBackgroundColor: const Color(0xFF020617),
        useMaterial3: true,
      );

  static ThemeData materialLight() => ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF38BDF8),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      );
}

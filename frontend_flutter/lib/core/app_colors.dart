import 'package:flutter/material.dart';

class AppColors {
  // Primary theme colors
  static const Color primary = Color(0xFF1565C0);
  static const Color accent = Color(0xFF42A5F5);

  static const Color surface = Colors.white; // ✅ fixed (was error)
  static const Color muted = Color(0xFF9E9E9E); // ✅ fixed (was error)

  // Backgrounds
  static const Color background = Colors.white;
  static const Color scaffoldBackground = Color(0xFFF5F5F5);

  // Text colors
  static const Color textDark = Colors.black87;
  static const Color textLight = Colors.white70;
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Colors.grey;

  // States
  static const Color error = Colors.redAccent;
  static const Color success = Colors.green;
  static const Color warning = Colors.orangeAccent;

  // Borders / Dividers
  static const Color border = Color(0xFFDDDDDD);
  static const Color divider = Color(0xFFE0E0E0);

  // Buttons
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = accent;

  // Overlays
  static const Color overlay = Color(0x88000000);

  // Status colors
  static const Color pending = Color(0xFFF59E0B); // amber
  static const Color assigned = Color(0xFF2563EB); // blue
  static const Color resolved = Color(0xFF10B981); // green
  static const Color verified = Color(0xFF9333EA); // purple
}

import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color navy = Color(0xFF17365D);
  static const Color blue = Color(0xFF2F75B5);
  static const Color blue2 = Color(0xFF5B9BD5);
  static const Color blue50 = Color(0xFFF3F7FB);
  static const Color blue100 = Color(0xFFD9EAF7);

  // Status Colors
  static const Color green = Color(0xFF2F855A);
  static const Color green50 = Color(0xFFE8F5ED);
  static const Color amber = Color(0xFFB7791F);
  static const Color amber50 = Color(0xFFFFF7DF);
  static const Color red = Color(0xFFC53030);
  static const Color red50 = Color(0xFFFFF0F0);

  // Neutral Colors (Light Theme)
  static const Color ink = Color(0xFF1F2937);
  static const Color muted = Color(0xFF667085);
  static const Color line = Color(0xFFD9E2EC);
  static const Color panel = Color(0xFFFFFFFF);
  static const Color page = Color(0xFFF5F7FA);

  // Dark Theme Colors
  static const Color darkPage = Color(0xFF0F172A); // Slate 900
  static const Color darkPanel = Color(0xFF1E293B); // Slate 800
  static const Color darkInk = Color(0xFFF8FAFC); // Slate 50
  static const Color darkMuted = Color(0xFF94A3B8); // Slate 400
  static const Color darkLine = Color(0xFF334155); // Slate 700

  // Shadows
  static const List<BoxShadow> shadow = [
    BoxShadow(
      color: Color(0x1417365D), // rgba(23,54,93,.08)
      blurRadius: 24,
      offset: Offset(0, 8),
    )
  ];
}

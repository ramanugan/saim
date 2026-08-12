import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.navy,
      scaffoldBackgroundColor: AppColors.page,
      colorScheme: ColorScheme.light(
        primary: AppColors.navy,
        secondary: AppColors.blue,
        error: AppColors.red,
        background: AppColors.page,
        surface: AppColors.panel,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        bodyLarge: GoogleFonts.inter(color: AppColors.ink, fontSize: 14),
        bodyMedium: GoogleFonts.inter(color: AppColors.ink, fontSize: 13),
        titleLarge: GoogleFonts.inter(color: AppColors.navy, fontWeight: FontWeight.bold),
        titleMedium: GoogleFonts.inter(color: AppColors.navy, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.panel,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.ink),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
          elevation: 4,
          shadowColor: AppColors.blue.withOpacity(0.22),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          backgroundColor: Colors.white,
          side: BorderSide(color: Color(0xFFB8C8D8)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFCBD6E2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFCBD6E2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.blue, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: Color(0xFF526174), fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.navy,
      scaffoldBackgroundColor: AppColors.darkPage,
      colorScheme: ColorScheme.dark(
        primary: AppColors.blue,
        secondary: AppColors.blue2,
        error: AppColors.red,
        background: AppColors.darkPage,
        surface: AppColors.darkPanel,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        bodyLarge: GoogleFonts.inter(color: AppColors.darkInk, fontSize: 14),
        bodyMedium: GoogleFonts.inter(color: AppColors.darkInk, fontSize: 13),
        titleLarge: GoogleFonts.inter(color: AppColors.blue50, fontWeight: FontWeight.bold),
        titleMedium: GoogleFonts.inter(color: AppColors.blue50, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkPanel,
        foregroundColor: AppColors.darkInk,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.darkInk),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.blue50,
          backgroundColor: AppColors.darkPanel,
          side: BorderSide(color: AppColors.darkLine),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkPanel,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.darkLine),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.darkLine),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.blue, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: AppColors.darkMuted, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

extension BuildContextThemeExt on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  Color get surfaceColor => Theme.of(this).colorScheme.surface;
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get textColor => isDarkMode ? AppColors.darkInk : AppColors.navy;
  Color get mutedTextColor => isDarkMode ? AppColors.darkMuted : AppColors.muted;
  Color get borderColor => isDarkMode ? AppColors.darkLine : AppColors.line;
}


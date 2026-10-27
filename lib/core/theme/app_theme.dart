import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralised theme configuration for Homivo.
/// Font: Poppins (matches the UI — rounded, geometric, modern).
class AppTheme {
  AppTheme._();

  // ── Brand colours ──────────────────────────────────────────────────────────
  static const Color primary      = Color(0xFF00C566);
  static const Color primaryDark  = Color(0xFF00A855);
  static const Color primaryLight = Color(0xFFD0F5E8);
  static const Color accent       = Color(0xFF1A1A2E);
  static const Color textGrey     = Color(0xFF8A8A9A);
  static const Color bgWhite      = Color(0xFFFFFFFF);

  // ── Extended design tokens (shared client + provider) ─────────────────────
  static const Color skyBlue      = Color(0xFF26C6DA);
  static const Color skyBlueLight = Color(0xFFE0F7FA);
  static const Color deepPurple   = Color(0xFF7E57C2);
  static const Color deepPurpleLight = Color(0xFFEDE7F6);
  static const Color amber        = Color(0xFFF59E0B);
  static const Color amberLight   = Color(0xFFFEF3C7);
  static const Color bgPage       = Color(0xFFF6F8FA);

  // ── Poppins text theme ─────────────────────────────────────────────────────
  static TextTheme get _textTheme => GoogleFonts.poppinsTextTheme(
        const TextTheme(
          // Display
          displayLarge:  TextStyle(fontSize: 57, fontWeight: FontWeight.w700),
          displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w700),
          displaySmall:  TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
          // Headline
          headlineLarge:  TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          headlineSmall:  TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          // Title
          titleLarge:  TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          titleSmall:  TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          // Body
          bodyLarge:   TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          bodyMedium:  TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          bodySmall:   TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          // Label
          labelLarge:  TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          labelSmall:  TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      );

  // ── Light theme ────────────────────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: primaryDark,
        ),
        scaffoldBackgroundColor: bgWhite,
        // Apply Poppins to every text widget in the app
        textTheme: _textTheme,
        primaryTextTheme: _textTheme,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: accent,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: textGrey,
            fontWeight: FontWeight.w400,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
        ),
      );
}

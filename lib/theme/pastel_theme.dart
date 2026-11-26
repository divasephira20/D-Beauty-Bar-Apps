import 'package:flutter/material.dart';

class PastelTheme {
  // Brand Dark & Charcoal Anchors
  static const Color brandDark = Color(0xFF18181B);
  static const Color charcoal = Color(0xFF232326);
  static const Color charcoalMuted = Color(0xFF27272A);
  
  // Soft Pastel Tones (Blush Pink, Sage Mint, Butter Yellow)
  static const Color pastelPink = Color(0xFFFDEBEF);
  static const Color pastelPinkSoft = Color(0xFFFCEAEB);
  static const Color pastelPinkLight = Color(0xFFFFF3F5);
  static const Color pastelPinkBorder = Color(0xFFF6DCE0);
  static const Color pastelPinkText = Color(0xFF9B3D4A);

  static const Color pastelMint = Color(0xFFE8F5EE);
  static const Color pastelMintSoft = Color(0xFFE7F6ED);
  static const Color pastelMintLight = Color(0xFFF1FAF4);
  static const Color pastelMintBorder = Color(0xFFD5EEDD);
  static const Color pastelMintText = Color(0xFF26623B);

  static const Color pastelYellow = Color(0xFFFEF8E7);
  static const Color pastelYellowSoft = Color(0xFFFEF8DD);
  static const Color pastelYellowLight = Color(0xFFFFFDF0);
  static const Color pastelYellowBorder = Color(0xFFF5ECC4);
  static const Color pastelYellowText = Color(0xFF966C0F);

  // Backgrounds & Neutrals
  static const Color background = Color(0xFFFEF9F5);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color subtleGray = Color(0xFF71717A);
  static const Color borderSoft = Color(0xFFF1EBE6);
  static const Color mutedText = Color(0xFFA1A1AA);
  static const Color softText = Color(0xFF1E1E24);

  // Background Gradient (Screen canvas)
  static const LinearGradient screenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF0F3), // Pastel pink tint
      Color(0xFFFFF8F0), // Soft cream
      Color(0xFFF5FBF7), // Mint breath
      Color(0xFFFDFBF0), // Warm butter finish
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  // Card Gradients
  static const LinearGradient pinkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFDEBEF), Color(0xFFFADAE0)],
  );

  static const LinearGradient mintCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEEFAF2), Color(0xFFD6F1E1)],
  );

  static const LinearGradient yellowCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFCEB), Color(0xFFFBF1C5)],
  );

  static const LinearGradient heroCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFE8EB),
      Color(0xFFFFF2EB),
      Color(0xFFFEF5D6),
    ],
  );

  static const LinearGradient charcoalButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF27272A), Color(0xFF18181B)],
  );

  // Radii
  static const double radiusPill = 9999.0;
  static const double radiusCard = 26.0;
  static const double radiusCardLg = 28.0;
  static const double radiusSubcard = 18.0;
  static const double radiusSm = 12.0;

  // Box Shadows
  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> dockShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 30,
      offset: Offset(0, 10),
    ),
  ];

  static const List<BoxShadow> charcoalButtonShadow = [
    BoxShadow(
      color: Color(0x3B18181B),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  // ThemeData
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: brandDark,
      colorScheme: const ColorScheme.light(
        primary: brandDark,
        onPrimary: Colors.white,
        secondary: pastelPinkText,
        surface: surfaceCard,
      ),
      fontFamily: 'Plus Jakarta Sans',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: brandDark),
      ),
    );
  }
}

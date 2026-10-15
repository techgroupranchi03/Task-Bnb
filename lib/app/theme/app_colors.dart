import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Brand / Layout ─────────────────────────────────────
  /// Deep forest green — primary layout / background tone
  static const Color layout = Color(0xFF132421);

  // ── Active (Deep Teal Green) ───────────────────────────
  /// Active state base
  static const Color primary = Color(0xFF2E614D);
  /// Active state — lighter variant
  static const Color primaryLight = Color(0xFF407F68);
  /// Active state — darker variant
  static const Color primaryDark = Color(0xFF1E4535);

  // ── Interactive (Warm Gold) ────────────────────────────
  /// Interactive / CTA base
  static const Color secondary = Color(0xFFB08338);
  /// Interactive — lighter variant
  static const Color secondaryLight = Color(0xFFCB9D4E);
  /// Interactive — darker variant
  static const Color secondaryDark = Color(0xFFB06038);

  // ── Accent ────────────────────────────────────────────
  /// Soft sage green — notifications / highlights
  static const Color accent = Color(0xFF7BB762);

  // ── Neutrals ───────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF132421);

  static const Color grey50  = Color(0xFFFDFBF2);   // Surface tone
  static const Color grey100 = Color(0xFFF5F0E0);
  static const Color grey200 = Color(0xFFE8E0C8);
  static const Color grey300 = Color(0xFFD0C8A8);
  static const Color grey400 = Color(0xFFAA9E7E);
  static const Color grey500 = Color(0xFF7A7260);
  static const Color grey600 = Color(0xFF5A5448);
  static const Color grey700 = Color(0xFF3E3A30);
  static const Color grey800 = Color(0xFF2A2720);
  static const Color grey900 = Color(0xFF132421);

  // ── Semantic ───────────────────────────────────────────
  /// Success — mapped to the notification green
  static const Color success = Color(0xFF7BB762);
  static const Color successLight = Color(0xFFD4EFD0);

  /// Warning — mapped to the warm gold interactive
  static const Color warning = Color(0xFFB08338);
  static const Color warningLight = Color(0xFFF5E8C8);

  /// Error — kept as a clear red for universal recognition
  static const Color error = Color(0xFFD94040);
  static const Color errorLight = Color(0xFFFCE4E4);

  /// Info — mapped to the active teal
  static const Color info = Color(0xFF2E614D);
  static const Color infoLight = Color(0xFFCCE4DC);

  // ── Surface ────────────────────────────────────────────
  /// Warm off-white surface
  static const Color surface = Color(0xFFFDFBF2);
  static const Color surfaceVariant = Color(0xFFF0EDE0);
  static const Color background = Color(0xFFFDFBF2);
  static const Color onSurface = Color(0xFF132421);
  static const Color outline = Color(0xFFD0C8A8);
}

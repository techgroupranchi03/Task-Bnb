import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

class AppTheme {
  AppTheme._();

  // ── Light Theme ────────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: AppTypography.fontFamily,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.white,
          primaryContainer: AppColors.primaryLight,
          secondary: AppColors.secondary,
          onSecondary: AppColors.white,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          error: AppColors.error,
          onError: AppColors.white,
          outline: AppColors.outline,
        ),
        textTheme: const TextTheme(
          displayLarge: AppTypography.displayLarge,
          displayMedium: AppTypography.displayMedium,
          headlineLarge: AppTypography.headlineLarge,
          headlineMedium: AppTypography.headlineMedium,
          headlineSmall: AppTypography.headlineSmall,
          titleLarge: AppTypography.titleLarge,
          titleMedium: AppTypography.titleMedium,
          titleSmall: AppTypography.titleSmall,
          bodyLarge: AppTypography.bodyLarge,
          bodyMedium: AppTypography.bodyMedium,
          bodySmall: AppTypography.bodySmall,
          labelLarge: AppTypography.labelLarge,
          labelMedium: AppTypography.labelMedium,
          labelSmall: AppTypography.labelSmall,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          elevation: 0,
          scrolledUnderElevation: 1,
          titleTextStyle: AppTypography.titleLarge,
        ),
        cardTheme: CardTheme(
          color: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            side: const BorderSide(color: AppColors.outline),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            minimumSize: const Size(double.infinity, AppSpacing.buttonHeightMd),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            textStyle: AppTypography.labelLarge,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, AppSpacing.buttonHeightMd),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            side: const BorderSide(color: AppColors.primary),
            textStyle: AppTypography.labelLarge,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.grey50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          hintStyle: AppTypography.bodyMedium,
          labelStyle: AppTypography.bodyMedium,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey500,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: AppTypography.labelSmall,
          unselectedLabelStyle: AppTypography.labelSmall,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppColors.white,
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.outline,
          thickness: 1,
        ),
      );

  // ── Dark Theme ─────────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: AppTypography.fontFamily,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryLight,
          onPrimary: AppColors.white,
          primaryContainer: AppColors.primaryDark,
          secondary: AppColors.secondaryLight,
          onSecondary: AppColors.white,
          surface: Color(0xFF1E293B),
          onSurface: Color(0xFFE2E8F0),
          error: AppColors.error,
          onError: AppColors.white,
          outline: Color(0xFF334155),
        ),
        textTheme: TextTheme(
          displayLarge: AppTypography.displayLarge.copyWith(color: const Color(0xFFE2E8F0)),
          displayMedium: AppTypography.displayMedium.copyWith(color: const Color(0xFFE2E8F0)),
          headlineLarge: AppTypography.headlineLarge.copyWith(color: const Color(0xFFF1F5F9)),
          headlineMedium: AppTypography.headlineMedium.copyWith(color: const Color(0xFFF1F5F9)),
          headlineSmall: AppTypography.headlineSmall.copyWith(color: const Color(0xFFF1F5F9)),
          titleLarge: AppTypography.titleLarge.copyWith(color: const Color(0xFFF1F5F9)),
          titleMedium: AppTypography.titleMedium.copyWith(color: const Color(0xFFE2E8F0)),
          titleSmall: AppTypography.titleSmall.copyWith(color: const Color(0xFFE2E8F0)),
          bodyLarge: AppTypography.bodyLarge.copyWith(color: const Color(0xFFCBD5E1)),
          bodyMedium: AppTypography.bodyMedium.copyWith(color: const Color(0xFFCBD5E1)),
          bodySmall: AppTypography.bodySmall.copyWith(color: const Color(0xFF94A3B8)),
          labelLarge: AppTypography.labelLarge.copyWith(color: const Color(0xFFE2E8F0)),
          labelMedium: AppTypography.labelMedium.copyWith(color: const Color(0xFFCBD5E1)),
          labelSmall: AppTypography.labelSmall.copyWith(color: const Color(0xFF94A3B8)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1E293B),
          foregroundColor: const Color(0xFFF1F5F9),
          elevation: 0,
          scrolledUnderElevation: 1,
          titleTextStyle: AppTypography.titleLarge.copyWith(color: const Color(0xFFF1F5F9)),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1E293B),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            side: const BorderSide(color: Color(0xFF334155)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            foregroundColor: AppColors.white,
            minimumSize: const Size(double.infinity, AppSpacing.buttonHeightMd),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            textStyle: AppTypography.labelLarge,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            minimumSize: const Size(double.infinity, AppSpacing.buttonHeightMd),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            side: const BorderSide(color: AppColors.primaryLight),
            textStyle: AppTypography.labelLarge,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E293B),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(color: const Color(0xFF64748B)),
          labelStyle: AppTypography.bodyMedium.copyWith(color: const Color(0xFF94A3B8)),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E293B),
          selectedItemColor: AppColors.primaryLight,
          unselectedItemColor: Color(0xFF64748B),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: AppTypography.labelSmall,
          unselectedLabelStyle: AppTypography.labelSmall,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFF1E293B),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF334155),
          thickness: 1,
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:mindlink/core/theme/app_colors.dart';

/// Light and dark Material 3 themes. Buttons are at least 52dp tall,
/// above the 48dp minimum tap target recommended by Material.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ).copyWith(
      primary: isDark ? AppColors.primaryDark : AppColors.primary,
      onPrimary: isDark ? AppColors.onPrimaryDark : Colors.white,
      surface: isDark ? AppColors.backgroundDark : AppColors.background,
      onSurface: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      onSurfaceVariant: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      error: isDark ? AppColors.errorDark : AppColors.error,
      onError: isDark ? AppColors.onErrorDark : Colors.white,
    );

    const radius = BorderRadius.all(Radius.circular(14));
    const buttonSize = Size(64, 52);
    const buttonText = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          shape: const RoundedRectangleBorder(borderRadius: radius),
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          shape: const RoundedRectangleBorder(borderRadius: radius),
          side: BorderSide(color: scheme.primary),
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        border: const OutlineInputBorder(borderRadius: radius),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}

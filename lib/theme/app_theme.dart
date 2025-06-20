import 'package:flutter/material.dart';
import 'design_tokens.dart';

class AppTheme {
  static const String defaultTheme = 'default';
  static const String greenTheme = 'green';
  static const String digitalGovDarkTheme = 'digital-gov-dark';

  static Map<String, DesignTokens> get availableTokens => {
        defaultTheme: DefaultDesignTokens(),
        digitalGovDarkTheme: DigitalGovDarkDesignTokens(),
      };

  static ThemeData createTheme(DesignTokens tokens) {
    // ダークテーマかどうかを判定
    final isDark = tokens is DigitalGovDarkDesignTokens;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: tokens.primary,
              onPrimary: tokens.onPrimary,
              primaryContainer: tokens.primaryContainer,
              onPrimaryContainer: tokens.onPrimaryContainer,
              secondary: tokens.secondary,
              onSecondary: tokens.onSecondary,
              surface: tokens.surface,
              onSurface: tokens.onSurface,
              surfaceVariant: tokens.surfaceVariant,
              onSurfaceVariant: tokens.onSurfaceVariant,
              outline: tokens.outline,
              error: tokens.error,
              onError: tokens.onError,
            )
          : ColorScheme.light(
              primary: tokens.primary,
              onPrimary: tokens.onPrimary,
              primaryContainer: tokens.primaryContainer,
              onPrimaryContainer: tokens.onPrimaryContainer,
              secondary: tokens.secondary,
              onSecondary: tokens.onSecondary,
              surface: tokens.surface,
              onSurface: tokens.onSurface,
              surfaceVariant: tokens.surfaceVariant,
              onSurfaceVariant: tokens.onSurfaceVariant,
              outline: tokens.outline,
              error: tokens.error,
              onError: tokens.onError,
            ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, tokens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.radiusLg),
          ),
          textStyle: TextStyle(
            fontSize: tokens.fontSizeLg,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Card theme
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusMd),
        ),
        elevation: 2,
      ),

      // Icon theme
      iconTheme: IconThemeData(
        size: tokens.fontSizeXl,
      ),

      // Text themes - デジタル庁準拠のタイポグラフィ
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: tokens.fontSizeXl,
          fontWeight: FontWeight.w600, // 少し軽めに
          letterSpacing: -0.5, // 文字間隔を調整
        ),
        titleLarge: TextStyle(
          fontSize: tokens.fontSizeLg,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.25,
        ),
        bodyMedium: TextStyle(
          fontSize: tokens.fontSizeMd,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontSize: tokens.fontSizeSm,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4,
        ),
      ),

      // AppBar theme - ダークテーマ対応
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: isDark ? tokens.surface : tokens.primary,
        foregroundColor: isDark ? tokens.onSurface : tokens.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  static ThemeData getThemeByName(String themeName) {
    final tokens = availableTokens[themeName] ?? DefaultDesignTokens();
    return createTheme(tokens);
  }
}

// Extension to easily access design tokens from BuildContext
extension DesignTokensExtension on BuildContext {
  DesignTokens get tokens {
    // This will be set by the ThemeProvider later
    return DefaultDesignTokens();
  }
}

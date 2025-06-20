import 'package:flutter/material.dart';
import 'design_tokens.dart';

class AppTheme {
  static const String defaultTheme = 'default';
  static const String greenTheme = 'green';

  static Map<String, DesignTokens> get availableTokens => {
    defaultTheme: DefaultDesignTokens(),
    greenTheme: GreenDesignTokens(),
  };

  static ThemeData createTheme(DesignTokens tokens) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
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

      // Text themes
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: tokens.fontSizeXl,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontSize: tokens.fontSizeLg,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          fontSize: tokens.fontSizeMd,
        ),
        labelMedium: TextStyle(
          fontSize: tokens.fontSizeSm,
        ),
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
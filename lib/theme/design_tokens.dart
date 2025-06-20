import 'package:flutter/material.dart';

abstract class DesignTokens {
  // Colors
  Color get primary;
  Color get onPrimary;
  Color get primaryContainer;
  Color get onPrimaryContainer;
  Color get secondary;
  Color get onSecondary;
  Color get surface;
  Color get onSurface;
  Color get surfaceVariant;
  Color get onSurfaceVariant;
  Color get outline;
  Color get success;
  Color get onSuccess;
  Color get warning;
  Color get onWarning;
  Color get error;
  Color get onError;

  // Spacing
  double get spacingXs;
  double get spacingSm;
  double get spacingMd;
  double get spacingLg;
  double get spacingXl;
  double get spacingXxl;

  // Border Radius
  double get radiusXs;
  double get radiusSm;
  double get radiusMd;
  double get radiusLg;

  // Typography
  double get fontSizeXs;
  double get fontSizeSm;
  double get fontSizeMd;
  double get fontSizeLg;
  double get fontSizeXl;
  double get fontSizeXxl;

  // Component specific
  double get buttonHeight;
  double get calendarCellSize;
  double get consecutiveDaysContainerHeight;
}

class DefaultDesignTokens implements DesignTokens {
  // Colors - Material Design 3 inspired
  @override
  Color get primary => const Color(0xFF6750A4);
  @override
  Color get onPrimary => const Color(0xFFFFFFFF);
  @override
  Color get primaryContainer => const Color(0xFFEADDFF);
  @override
  Color get onPrimaryContainer => const Color(0xFF21005D);
  @override
  Color get secondary => const Color(0xFF625B71);
  @override
  Color get onSecondary => const Color(0xFFFFFFFF);
  @override
  Color get surface => const Color(0xFFFFFBFE);
  @override
  Color get onSurface => const Color(0xFF1C1B1F);
  @override
  Color get surfaceVariant => const Color(0xFFE7E0EC);
  @override
  Color get onSurfaceVariant => const Color(0xFF49454F);
  @override
  Color get outline => const Color(0xFF79747E);
  @override
  Color get success => const Color(0xFF4CAF50);
  @override
  Color get onSuccess => const Color(0xFFFFFFFF);
  @override
  Color get warning => const Color(0xFFFF9800);
  @override
  Color get onWarning => const Color(0xFFFFFFFF);
  @override
  Color get error => const Color(0xFFBA1A1A);
  @override
  Color get onError => const Color(0xFFFFFFFF);

  // Spacing
  @override
  double get spacingXs => 4.0;
  @override
  double get spacingSm => 8.0;
  @override
  double get spacingMd => 16.0;
  @override
  double get spacingLg => 24.0;
  @override
  double get spacingXl => 32.0;
  @override
  double get spacingXxl => 48.0;

  // Border Radius
  @override
  double get radiusXs => 4.0;
  @override
  double get radiusSm => 8.0;
  @override
  double get radiusMd => 12.0;
  @override
  double get radiusLg => 16.0;

  // Typography
  @override
  double get fontSizeXs => 12.0;
  @override
  double get fontSizeSm => 14.0;
  @override
  double get fontSizeMd => 16.0;
  @override
  double get fontSizeLg => 18.0;
  @override
  double get fontSizeXl => 24.0;
  @override
  double get fontSizeXxl => 32.0;

  // Component specific
  @override
  double get buttonHeight => 80.0;
  @override
  double get calendarCellSize => 48.0;
  @override
  double get consecutiveDaysContainerHeight => 80.0;
}

class GreenDesignTokens implements DesignTokens {
  // Colors - Green theme variant
  @override
  Color get primary => const Color(0xFF388E3C);
  @override
  Color get onPrimary => const Color(0xFFFFFFFF);
  @override
  Color get primaryContainer => const Color(0xFFC8E6C9);
  @override
  Color get onPrimaryContainer => const Color(0xFF1B5E20);
  @override
  Color get secondary => const Color(0xFF689F38);
  @override
  Color get onSecondary => const Color(0xFFFFFFFF);
  @override
  Color get surface => const Color(0xFFF1F8E9);
  @override
  Color get onSurface => const Color(0xFF1B5E20);
  @override
  Color get surfaceVariant => const Color(0xFFDCEDC8);
  @override
  Color get onSurfaceVariant => const Color(0xFF33691E);
  @override
  Color get outline => const Color(0xFF8BC34A);
  @override
  Color get success => const Color(0xFF4CAF50);
  @override
  Color get onSuccess => const Color(0xFFFFFFFF);
  @override
  Color get warning => const Color(0xFFFF9800);
  @override
  Color get onWarning => const Color(0xFFFFFFFF);
  @override
  Color get error => const Color(0xFFD32F2F);
  @override
  Color get onError => const Color(0xFFFFFFFF);

  // Spacing (same as default)
  @override
  double get spacingXs => 4.0;
  @override
  double get spacingSm => 8.0;
  @override
  double get spacingMd => 16.0;
  @override
  double get spacingLg => 24.0;
  @override
  double get spacingXl => 32.0;
  @override
  double get spacingXxl => 48.0;

  // Border Radius (slightly more rounded)
  @override
  double get radiusXs => 6.0;
  @override
  double get radiusSm => 10.0;
  @override
  double get radiusMd => 14.0;
  @override
  double get radiusLg => 18.0;

  // Typography (same as default)
  @override
  double get fontSizeXs => 12.0;
  @override
  double get fontSizeSm => 14.0;
  @override
  double get fontSizeMd => 16.0;
  @override
  double get fontSizeLg => 18.0;
  @override
  double get fontSizeXl => 24.0;
  @override
  double get fontSizeXxl => 32.0;

  // Component specific
  @override
  double get buttonHeight => 80.0;
  @override
  double get calendarCellSize => 48.0;
  @override
  double get consecutiveDaysContainerHeight => 80.0;
}
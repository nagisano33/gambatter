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

class DigitalGovDarkDesignTokens implements DesignTokens {
  // Colors - デジタル庁デザインシステム準拠のダークテーマ
  @override
  Color get primary => const Color(0xFF4285F4); // デジタル庁ブルー（少し明るく調整）
  @override
  Color get onPrimary => const Color(0xFF000000);
  @override
  Color get primaryContainer => const Color(0xFF1A1A1A); // 深いグレー
  @override
  Color get onPrimaryContainer => const Color(0xFFE3F2FD);
  @override
  Color get secondary => const Color(0xFF64748B); // スレートグレー
  @override
  Color get onSecondary => const Color(0xFFFFFFFF);
  @override
  Color get surface => const Color(0xFF121212); // ダークサーフェス
  @override
  Color get onSurface => const Color(0xFFE1E1E1); // 高コントラスト文字
  @override
  Color get surfaceVariant => const Color(0xFF2A2A2A); // サーフェスバリアント
  @override
  Color get onSurfaceVariant => const Color(0xFFB0B0B0);
  @override
  Color get outline => const Color(0xFF3A3A3A); // 境界線
  @override
  Color get success => const Color(0xFF4CAF50);
  @override
  Color get onSuccess => const Color(0xFFFFFFFF);
  @override
  Color get warning => const Color(0xFFFF9800);
  @override
  Color get onWarning => const Color(0xFF000000);
  @override
  Color get error => const Color(0xFFCF6679); // ダークテーマ用エラーカラー
  @override
  Color get onError => const Color(0xFF000000);

  // Spacing - デジタル庁の8px基準
  @override
  double get spacingXs => 4.0;  // 8px ÷ 2
  @override
  double get spacingSm => 8.0;  // 基準値
  @override
  double get spacingMd => 16.0; // 8px × 2
  @override
  double get spacingLg => 24.0; // 8px × 3
  @override
  double get spacingXl => 32.0; // 8px × 4
  @override
  double get spacingXxl => 48.0; // 8px × 6

  // Border Radius - 控えめで洗練された角丸
  @override
  double get radiusXs => 2.0;
  @override
  double get radiusSm => 4.0;
  @override
  double get radiusMd => 8.0;
  @override
  double get radiusLg => 12.0;

  // Typography - 読みやすさを重視
  @override
  double get fontSizeXs => 12.0;
  @override
  double get fontSizeSm => 14.0;
  @override
  double get fontSizeMd => 16.0;
  @override
  double get fontSizeLg => 18.0;
  @override
  double get fontSizeXl => 22.0; // 少し控えめに
  @override
  double get fontSizeXxl => 28.0; // 少し控えめに

  // Component specific - シックな印象
  @override
  double get buttonHeight => 56.0; // 少し低く、洗練された印象
  @override
  double get calendarCellSize => 44.0; // 少し小さく
  @override
  double get consecutiveDaysContainerHeight => 72.0; // 少し低く
}
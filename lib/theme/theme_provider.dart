import 'package:flutter/material.dart';
import 'design_tokens.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  final DesignTokens _currentTokens = DigitalGovDarkDesignTokens();

  DesignTokens get currentTokens => _currentTokens;
  ThemeData get currentTheme => AppTheme.createTheme(_currentTokens);
}

// InheritedWidget to provide design tokens throughout the widget tree
class ThemeTokensProvider extends InheritedWidget {
  final DesignTokens tokens;

  const ThemeTokensProvider({
    super.key,
    required this.tokens,
    required super.child,
  });

  static DesignTokens of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ThemeTokensProvider>();
    return provider?.tokens ?? DefaultDesignTokens();
  }

  @override
  bool updateShouldNotify(ThemeTokensProvider oldWidget) {
    return tokens != oldWidget.tokens;
  }
}

// Updated extension to use the provider
extension DesignTokensContext on BuildContext {
  DesignTokens get designTokens => ThemeTokensProvider.of(this);
}
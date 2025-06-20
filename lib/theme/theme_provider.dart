import 'package:flutter/material.dart';
import 'design_tokens.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  String _currentThemeName = AppTheme.defaultTheme;
  late DesignTokens _currentTokens;

  ThemeProvider() {
    _currentTokens = AppTheme.availableTokens[_currentThemeName]!;
  }

  String get currentThemeName => _currentThemeName;
  DesignTokens get currentTokens => _currentTokens;
  ThemeData get currentTheme => AppTheme.createTheme(_currentTokens);

  List<String> get availableThemeNames => AppTheme.availableTokens.keys.toList();

  void setTheme(String themeName) {
    if (AppTheme.availableTokens.containsKey(themeName)) {
      _currentThemeName = themeName;
      _currentTokens = AppTheme.availableTokens[themeName]!;
      notifyListeners();
    }
  }

  void toggleTheme() {
    final themeNames = availableThemeNames;
    final currentIndex = themeNames.indexOf(_currentThemeName);
    final nextIndex = (currentIndex + 1) % themeNames.length;
    setTheme(themeNames[nextIndex]);
  }
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
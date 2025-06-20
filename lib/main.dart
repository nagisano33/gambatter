import 'package:flutter/material.dart';
import 'my_homepage.dart';
import 'theme/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeProvider,
      builder: (context, child) {
        return ThemeTokensProvider(
          tokens: _themeProvider.currentTokens,
          child: MaterialApp(
            title: 'Gambatter',
            theme: _themeProvider.currentTheme,
            home: MyHomePage(
              title: 'Gambatter',
              themeProvider: _themeProvider,
            ),
          ),
        );
      },
    );
  }
}

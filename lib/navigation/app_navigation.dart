import 'package:flutter/material.dart';
import '../screens/flame_record_screen.dart';
import '../screens/statistics_screen.dart';
import '../theme/theme_provider.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({
    super.key,
    required this.title,
    required this.themeProvider,
  });

  final String title;
  final ThemeProvider themeProvider;

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;

  void _onRecordCompleted() {
    // 記録完了後に統計画面に自動遷移
    setState(() {
      _currentIndex = 1;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.designTokens;

    final List<Widget> screens = [
      FlameRecordScreen(onRecordCompleted: _onRecordCompleted),
      const StatisticsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: tokens.surface,
        selectedItemColor: tokens.primary,
        unselectedItemColor: tokens.onSurfaceVariant,
        selectedLabelStyle: TextStyle(
          fontSize: tokens.fontSizeSm,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: tokens.fontSizeSm,
          fontWeight: FontWeight.w400,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: '記録',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: '統計',
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../widgets/consecutive_days_display.dart';
import '../widgets/monthly_calendar.dart';
import '../theme/theme_provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final dbHelper = DatabaseHelper.instance;

  int _consecutiveDays = 0;
  List<DateTime> _recordedDates = [];
  DateTime _currentMonth = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    await _loadConsecutiveDays();
    await _loadMonthlyRecords();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadConsecutiveDays() async {
    final consecutiveDays = await dbHelper.getConsecutiveDaysCount();
    setState(() {
      _consecutiveDays = consecutiveDays;
    });
  }

  Future<void> _loadMonthlyRecords() async {
    final records = await dbHelper.getEffortRecordsForMonth(
      _currentMonth.year,
      _currentMonth.month,
    );
    setState(() {
      _recordedDates = records;
    });
  }

  Future<void> _onMonthChanged(int year, int month) async {
    setState(() {
      _currentMonth = DateTime(year, month);
    });
    await _loadMonthlyRecords();
  }

  Future<void> _deleteTodayRecord() async {
    final shouldDelete = await _showDeleteConfirmDialog(
      '今日の記録を削除しますか？',
      '今日の頑張り記録が削除されます。',
    );

    if (shouldDelete == true) {
      try {
        await dbHelper.deleteTodayRecord();
        await _loadData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('今日の記録を削除しました'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('削除に失敗しました'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteAllRecords() async {
    final shouldDelete = await _showDeleteConfirmDialog(
      '全データを削除しますか？',
      'すべての頑張り記録が完全に削除されます。\nこの操作は元に戻せません。',
    );

    if (shouldDelete == true) {
      try {
        await dbHelper.deleteAllRecords();
        await _loadData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('全データを削除しました'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('削除に失敗しました'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  Future<void> _createTestData() async {
    try {
      await dbHelper.createConsecutiveRecords(7);
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('7日間のテストデータを作成しました'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('テストデータの作成に失敗しました'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<bool?> _showDeleteConfirmDialog(String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('削除'),
            ),
          ],
        );
      },
    );
  }

  void _showDebugPanel() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final tokens = context.designTokens;
        return Container(
          padding: EdgeInsets.all(tokens.spacingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.bug_report),
                  SizedBox(width: tokens.spacingSm),
                  const Text(
                    'デバッグパネル',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: tokens.spacingMd),
              Text('連続記録日数: $_consecutiveDays日'),
              Text('今月の記録数: ${_recordedDates.length}日'),
              SizedBox(height: tokens.spacingMd),
              Wrap(
                spacing: tokens.spacingSm,
                children: [
                  ElevatedButton(
                    onPressed: _deleteTodayRecord,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                    ),
                    child: const Text('今日の記録削除'),
                  ),
                  ElevatedButton(
                    onPressed: _createTestData,
                    child: const Text('7日間データ作成'),
                  ),
                  ElevatedButton(
                    onPressed: _deleteAllRecords,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                    ),
                    child: const Text('全データ削除'),
                  ),
                ],
              ),
              SizedBox(height: tokens.spacingMd),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.designTokens;

    return Scaffold(
      appBar: AppBar(
        title: const Text('統計'),
        automaticallyImplyLeading: false, // 戻るボタンを非表示
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: tokens.spacingMd),
                    ConsecutiveDaysDisplay(consecutiveDays: _consecutiveDays),
                    SizedBox(height: tokens.spacingMd),
                    MonthlyCalendar(
                      recordedDates: _recordedDates,
                      onMonthChanged: _onMonthChanged,
                    ),
                    SizedBox(height: tokens.spacingMd),
                  ],
                ),
              ),
            ),
      floatingActionButton: kDebugMode
          ? FloatingActionButton(
              onPressed: _showDebugPanel,
              backgroundColor: Theme.of(context).colorScheme.error,
              child: const Icon(Icons.bug_report),
            )
          : null,
    );
  }
}
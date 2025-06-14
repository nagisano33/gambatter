import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'widgets/consecutive_days_display.dart';
import 'widgets/effort_button.dart';
import 'widgets/monthly_calendar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;
  
  int _consecutiveDays = 0;
  bool _isRecordedToday = false;
  bool _isLoading = false;
  List<DateTime> _recordedDates = [];
  DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadConsecutiveDays();
    await _checkTodayRecord();
    await _loadMonthlyRecords();
  }

  Future<void> _loadConsecutiveDays() async {
    final consecutiveDays = await dbHelper.getConsecutiveDaysCount();
    setState(() {
      _consecutiveDays = consecutiveDays;
    });
  }

  Future<void> _checkTodayRecord() async {
    final today = DateTime.now();
    final isRecorded = await dbHelper.hasEffortRecordForDate(today);
    setState(() {
      _isRecordedToday = isRecorded;
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

  Future<void> _recordEffort() async {
    if (_isRecordedToday || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final today = DateTime.now();
      await dbHelper.insertEffortRecord(today);
      
      await _loadData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('今日の頑張りを記録しました！'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('記録に失敗しました。もう一度お試しください。'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onMonthChanged(int year, int month) async {
    setState(() {
      _currentMonth = DateTime(year, month);
    });
    await _loadMonthlyRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            ConsecutiveDaysDisplay(consecutiveDays: _consecutiveDays),
            const SizedBox(height: 16),
            EffortButton(
              onPressed: _recordEffort,
              isRecordedToday: _isRecordedToday,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
            MonthlyCalendar(
              recordedDates: _recordedDates,
              onMonthChanged: _onMonthChanged,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';

class MonthlyCalendar extends StatefulWidget {
  final List<DateTime> recordedDates;
  final Function(int year, int month) onMonthChanged;

  const MonthlyCalendar({
    super.key,
    required this.recordedDates,
    required this.onMonthChanged,
  });

  @override
  State<MonthlyCalendar> createState() => _MonthlyCalendarState();
}

class _MonthlyCalendarState extends State<MonthlyCalendar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
    widget.onMonthChanged(_currentMonth.year, _currentMonth.month);
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
    widget.onMonthChanged(_currentMonth.year, _currentMonth.month);
  }

  bool _isRecorded(DateTime date) {
    return widget.recordedDates.any((recordedDate) =>
        recordedDate.year == date.year &&
        recordedDate.month == date.month &&
        recordedDate.day == date.day);
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final startDate = firstDay.subtract(Duration(days: firstDay.weekday % 7));
    
    List<DateTime> days = [];
    for (int i = 0; i < 42; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    
    return days;
  }

  String _getMonthYearText(DateTime date) {
    const months = [
      '1月', '2月', '3月', '4月', '5月', '6月',
      '7月', '8月', '9月', '10月', '11月', '12月'
    ];
    return '${date.year}年 ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.designTokens;
    final days = _getDaysInMonth(_currentMonth);

    return Container(
      margin: EdgeInsets.all(tokens.spacingMd),
      padding: EdgeInsets.all(tokens.spacingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(tokens.radiusMd),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                _getMonthYearText(_currentMonth),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          SizedBox(height: tokens.spacingMd),
          Row(
            children: ['日', '月', '火', '水', '木', '金', '土']
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: tokens.spacingSm),
          ...List.generate(6, (weekIndex) {
            return Row(
              children: List.generate(7, (dayIndex) {
                final dayDate = days[weekIndex * 7 + dayIndex];
                final isCurrentMonth = dayDate.month == _currentMonth.month;
                final isRecorded = _isRecorded(dayDate);
                final isToday = _isToday(dayDate);

                return Expanded(
                  child: Container(
                    height: tokens.calendarCellSize,
                    margin: EdgeInsets.all(tokens.spacingXs / 2),
                    decoration: BoxDecoration(
                      color: isRecorded
                          ? Theme.of(context).colorScheme.primary
                          : isToday
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                      borderRadius: BorderRadius.circular(tokens.radiusSm),
                      border: isToday && !isRecorded
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '${dayDate.day}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: !isCurrentMonth
                              ? Theme.of(context).colorScheme.onSurface.withOpacity(0.3)
                              : isRecorded
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : isToday
                                      ? Theme.of(context).colorScheme.onPrimaryContainer
                                      : Theme.of(context).colorScheme.onSurface,
                          fontWeight: isToday || isRecorded ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}
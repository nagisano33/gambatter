import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static const _databaseName = "Gambatter.db";
  static const _databaseVersion = 1;

  static const tableEffortRecords = 'effort_records';
  static const columnId = 'id';
  static const columnRecordedDate = 'recorded_date';
  static const columnRecordedAt = 'recorded_at';
  static const columnCategoryId = 'category_id';
  static const columnMemo = 'memo';
  static const columnCreatedAt = 'created_at';
  static const columnUpdatedAt = 'updated_at';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableEffortRecords (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnRecordedDate DATE NOT NULL UNIQUE,
            $columnRecordedAt DATETIME NOT NULL,
            $columnCategoryId INTEGER,
            $columnMemo TEXT,
            $columnCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
            $columnUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
          )
          ''');
  }

  Future<int> insertEffortRecord(DateTime date) async {
    Database db = await instance.database;
    String dateString = _formatDate(date);
    String datetimeString = date.toIso8601String();
    
    Map<String, dynamic> row = {
      columnRecordedDate: dateString,
      columnRecordedAt: datetimeString,
    };
    
    return await db.insert(tableEffortRecords, row);
  }

  Future<bool> hasEffortRecordForDate(DateTime date) async {
    Database db = await instance.database;
    String dateString = _formatDate(date);
    
    List<Map<String, dynamic>> result = await db.query(
      tableEffortRecords,
      where: '$columnRecordedDate = ?',
      whereArgs: [dateString],
    );
    
    return result.isNotEmpty;
  }

  Future<List<DateTime>> getEffortRecordsForMonth(int year, int month) async {
    Database db = await instance.database;
    String monthStart = '$year-${month.toString().padLeft(2, '0')}-01';
    String monthEnd = '$year-${month.toString().padLeft(2, '0')}-31';
    
    List<Map<String, dynamic>> result = await db.query(
      tableEffortRecords,
      columns: [columnRecordedDate],
      where: '$columnRecordedDate >= ? AND $columnRecordedDate <= ?',
      whereArgs: [monthStart, monthEnd],
      orderBy: '$columnRecordedDate ASC',
    );
    
    return result.map((row) => DateTime.parse(row[columnRecordedDate])).toList();
  }

  Future<int> getConsecutiveDaysCount() async {
    Database db = await instance.database;
    
    List<Map<String, dynamic>> allRecords = await db.query(
      tableEffortRecords,
      columns: [columnRecordedDate],
      orderBy: '$columnRecordedDate DESC',
    );
    
    if (allRecords.isEmpty) return 0;
    
    List<DateTime> recordDates = allRecords
        .map((row) => DateTime.parse(row[columnRecordedDate]))
        .toList();
    
    DateTime today = DateTime.now();
    DateTime todayDate = DateTime(today.year, today.month, today.day);
    
    int consecutiveDays = 0;
    DateTime checkDate = todayDate;
    
    for (DateTime recordDate in recordDates) {
      DateTime recordDateOnly = DateTime(recordDate.year, recordDate.month, recordDate.day);
      
      if (recordDateOnly == checkDate) {
        consecutiveDays++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (recordDateOnly.isBefore(checkDate)) {
        break;
      }
    }
    
    return consecutiveDays;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
# Gambatter Flutter Project - Claude Code Configuration

## Project Overview
- **Project Name**: Gambatter
- **Description**: 日々の「頑張り」を記録・可視化するモチベーション管理アプリ
- **Platform**: iOS, Android対応
- **Version**: 1.0.0+1

## Flutter Environment
- **Dart SDK**: >=2.19.4 <3.0.0
- **Flutter Version**: 標準版（最新安定版推奨）

## Dependencies
### Main Dependencies
- `flutter` (SDK)
- `cupertino_icons: ^1.0.2` - iOS風アイコン
- `sqflite: ^2.2.8+4` - SQLiteデータベース
- `path_provider: ^2.1.1` - ファイルパス取得
- `path: ^1.8.0` - パス操作ユーティリティ

### Dev Dependencies
- `flutter_test` (SDK)
- `flutter_lints: ^2.0.0` - Dartコード品質チェック

## Project Structure
```
lib/
├── main.dart                              # アプリのエントリーポイント
├── my_homepage.dart                       # メイン画面（3つのウィジェット統合）
├── database_helper.dart                   # SQLiteデータベースヘルパー
└── widgets/                               # UIコンポーネント
    ├── consecutive_days_display.dart      # 連続記録日数表示ウィジェット
    ├── effort_button.dart                 # 頑張ったボタンウィジェット
    └── monthly_calendar.dart              # 月間カレンダーウィジェット
```

## Key Features
- **頑張り記録機能**: 1日1回の記録制限付き
- **連続記録日数表示**: 継続日数の可視化
- **月間カレンダー**: 記録履歴のカレンダー表示
- **SQLiteデータ永続化**: ローカルデータベース管理
- **将来拡張対応**: カテゴリ・メモ・クラウド同期対応設計

## Architecture Pattern
- **Widget分割設計**: React風のコンポーネント分割
- **StatefulWidget**: 状態管理とライフサイクル管理
- **DatabaseHelper**: シングルトンパターンでDB操作分離
- **エラーハンドリング**: 適切な例外処理とユーザーフィードバック

## UI Components
### ConsecutiveDaysDisplay
- 連続記録日数の表示
- 炎アイコンと数値のレイアウト
- Material Design 3 準拠

### EffortButton
- タップアニメーション付きボタン
- 記録済み状態の視覚的フィードバック
- ローディング状態の表示

### MonthlyCalendar
- 月間グリッドレイアウト
- 記録日のハイライト表示
- 月切り替えナビゲーション

## Database Schema
```sql
CREATE TABLE effort_records (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  recorded_date DATE NOT NULL UNIQUE,     -- YYYY-MM-DD形式
  recorded_at DATETIME NOT NULL,          -- 記録時刻
  category_id INTEGER,                    -- 将来のカテゴリ機能用
  memo TEXT,                             -- 将来のメモ機能用
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## Common Commands
```bash
# 依存関係インストール
flutter pub get

# アプリ実行（開発モード）
flutter run

# テスト実行
flutter test

# コード品質チェック
flutter analyze

# APK/IPAビルド
flutter build apk
flutter build ios

# クリーンビルド
flutter clean && flutter pub get
```

## Key Methods (DatabaseHelper)
- `insertEffortRecord(DateTime)` - 頑張り記録の保存
- `hasEffortRecordForDate(DateTime)` - 日付での重複チェック
- `getEffortRecordsForMonth(int, int)` - 月間記録取得
- `getConsecutiveDaysCount()` - 連続記録日数計算

## Coding Conventions
- Dartの標準スタイルガイドに従う
- `flutter_lints`の推奨ルールを適用
- クラス名はPascalCase、変数名はcamelCase
- プライベートメンバーは先頭にアンダースコア
- Widgetの小分割による保守性向上
- 適切なエラーハンドリングとローディング状態管理

## File Naming
- Dartファイルは snake_case
- クラス名は PascalCase
- 定数は SCREAMING_SNAKE_CASE
- Widgetファイルは機能名_widget形式推奨

## Future Roadmap
### Phase 2 (中期)
- カテゴリ機能（勉強、運動、仕事など）
- メモ機能
- 統計画面（週間・月間グラフ）
- 目標設定機能

### Phase 3 (長期)
- クラウド同期
- 複数デバイス対応
- リマインダー機能
- 達成バッジ・励ましメッセージ
- データエクスポート機能
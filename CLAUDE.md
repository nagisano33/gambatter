# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

Gambatterは日々の「頑張り」を記録するFlutterモバイルアプリです。ユーザーは1日1回ボタンをタップして頑張りを記録し、連続記録日数と月間カレンダーで継続状況を可視化できます。1日1回制限により毎日の取り組みを促進します。

## 開発ワークフロー

**重要**: このプロジェクトでコード変更を行う際は、必ず以下の手順に従ってください：

### 1. 作業開始時の必須手順
```bash
# 現在のブランチ確認
git branch

# featureブランチ作成・切り替え（作業内容に応じた名前を使用）
git checkout -b feature/機能名-説明

# 例:
# git checkout -b feature/digital-gov-design-system
# git checkout -b feature/add-statistics-dashboard
# git checkout -b fix/calendar-display-bug
```

### 2. 作業完了時の手順
```bash
# 変更をステージング
git add .

# コミット（日本語または英語でOK）
git commit -m "feat: 機能の説明"

# 必要に応じてメインブランチにマージ
git checkout main
git merge feature/機能名-説明

# featureブランチ削除（任意）
git branch -d feature/機能名-説明
```

### 3. 開発コマンド
```bash
# 開発
flutter pub get                    # 依存関係インストール
flutter run                       # デバッグモードで実行
flutter analyze                   # 静的コード解析

# ビルド
flutter build apk                 # Android APKビルド
flutter build ios                 # iOS IPAビルド
flutter clean && flutter pub get  # 問題時のクリーンビルド

# テスト
flutter test                      # 全テスト実行
```

## アーキテクチャ概要

Reactライクな**ウィジェットベースのコンポーネント設計**を採用：

### プロジェクト構造
```
lib/
├── main.dart                    # アプリエントリーポイント
├── my_homepage.dart             # メイン画面・状態管理
├── database_helper.dart         # SQLiteデータ層
├── theme/                       # デザインシステム
│   ├── app_theme.dart          # テーマ設定
│   ├── design_tokens.dart      # デザイントークン
│   └── theme_provider.dart     # テーマプロバイダー
└── widgets/                     # UIコンポーネント
    ├── consecutive_days_display.dart
    ├── effort_button.dart
    └── monthly_calendar.dart
```

### 核となるコンポーネント構造
- **MyHomePage**: 3つの子ウィジェットを統合し、アプリ状態を管理するメイン画面
  - 5つの重要な状態変数を管理：`_consecutiveDays`、`_isRecordedToday`、`_isLoading`、`_recordedDates`、`_currentMonth`
  - データベースとUIコンポーネント間の調整役
- **ConsecutiveDaysDisplay**: 炎アイコン付きの連続記録日数表示（StatelessWidget）
- **EffortButton**: ローディング・完了状態を持つアニメーション付きボタン（AnimationController使用）
- **MonthlyCalendar**: 記録日をハイライト表示するカレンダーグリッド（42日グリッド = 6週×7日）

### データ層
- **DatabaseHelper**: SQLite操作を管理するシングルトンパターン
  - 遅延初期化でパフォーマンス最適化
  - 重要メソッド：`getConsecutiveDaysCount()`（複雑な連続日数計算）、`hasEffortRecordForDate()`（重複防止）
- **effort_recordsテーブル**: 将来拡張用フィールド（category_id、memo）を含むコアデータ

### テーマシステム（デザイントークンアーキテクチャ）
- **デザイントークン**: 抽象インターフェース + 具象実装（デジタル庁デザインシステム準拠のダークテーマ固定）
- **ThemeProvider**: ChangeNotifier + InheritedWidgetによる効率的なテーマ配信
- **カスタム拡張**: `context.designTokens`で簡単アクセス

### 主要データフロー
1. ユーザーが頑張りボタンをタップ → 今日の記録有無をチェック
2. 未記録の場合 → レコード挿入 → 連続記録日数を再計算
3. カレンダー表示を更新 → 成功フィードバック表示

### 状態管理パターン
- **ローカル状態**: 各ウィジェットが独自のUI状態を管理
- **共有状態**: テーマのみChangeNotifier + InheritedWidgetで管理
- **データ状態**: メインコーディネーターからの直接データベースアクセス

## データベーススキーマ

```sql
CREATE TABLE effort_records (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  recorded_date DATE NOT NULL UNIQUE,     -- YYYY-MM-DD形式
  recorded_at DATETIME NOT NULL,          -- タイムスタンプ
  category_id INTEGER,                    -- 将来使用
  memo TEXT,                             -- 将来使用
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## 重要なビジネスロジック

### 連続記録日数の計算
`getConsecutiveDaysCount()`メソッドは今日から過去に遡り、記録のある連続日数をカウントします。記録の途切れで停止し、今日が未記録の場合の edge case も処理します。

### 1日1回制限の実装
`hasEffortRecordForDate()`は対象日の既存エントリをチェックし、新規記録前に重複レコードを防止します。

## 将来拡張設計

データベーススキーマには未使用フィールド（category_id、memo）を含み、計画機能をサポート：
- **フェーズ2**: カテゴリ、メモ、統計ダッシュボード
- **フェーズ3**: クラウド同期、マルチデバイス、通知、ゲーミフィケーション

ウィジェット構造は拡張しやすく設計されており、新機能はメイン画面レイアウトに追加ウィジェットとして組み込めます。

## 依存関係

### コア依存関係
- `sqflite: ^2.2.8+4` - SQLiteデータベース
- `path_provider: ^2.1.1` - ファイルシステムパス
- `path: ^1.8.0` - パス操作ユーティリティ

### 開発依存関係
- `flutter_lints: ^2.0.0` - コード品質ルール

## 重要な実装パターン

### エラーハンドリング
MyHomePageの`_recordEffort()`メソッドでtry-catch + SnackBarによるユーザーフィードバックパターンを採用。

### パフォーマンス最適化
- StatelessWidget（ConsecutiveDaysDisplay）とStatefulWidget（EffortButton、MonthlyCalendar）の適切な使い分け
- DatabaseHelperのシングルトンパターンによるインスタンス管理
- InheritedWidgetによる効率的なテーマ配信

### テストの現状
- 基本的なウィジェットテストが存在するが更新が必要
- ビジネスロジックのユニットテストとデータベース操作の統合テストが未実装
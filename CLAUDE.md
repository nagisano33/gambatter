# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

Gambatterは日々の「頑張り」を記録するFlutterモバイルアプリです。ユーザーは1日1回ボタンをタップして頑張りを記録し、連続記録日数と月間カレンダーで継続状況を可視化できます。1日1回制限により毎日の取り組みを促進します。

## 必須コマンド

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

### 核となるコンポーネント構造
- **MyHomePage**: 3つの子ウィジェットを統合し、アプリ状態を管理するメイン画面
- **ConsecutiveDaysDisplay**: 炎アイコン付きの連続記録日数表示
- **EffortButton**: ローディング・完了状態を持つアニメーション付きボタン
- **MonthlyCalendar**: 記録日をハイライト表示するカレンダーグリッド

### データ層
- **DatabaseHelper**: SQLite操作を管理するシングルトンパターン
- **effort_recordsテーブル**: 将来拡張用フィールド（category_id、memo）を含むコアデータ

### 主要データフロー
1. ユーザーが頑張りボタンをタップ → 今日の記録有無をチェック
2. 未記録の場合 → レコード挿入 → 連続記録日数を再計算
3. カレンダー表示を更新 → 成功フィードバック表示

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
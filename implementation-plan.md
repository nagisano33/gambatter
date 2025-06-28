# UI改善実装計画

## コードベース分析結果

### 現状の強み
- **優秀なアーキテクチャ**: デザインシステム、アニメーション基盤が既に実装済み
- **拡張しやすい構造**: ウィジェットベースの設計で新機能追加が容易
- **堅牢なデータ層**: SQLiteとビジネスロジックが整備済み

### 実装が必要な主要変更点
1. **画面分割**: 単一画面 → 2画面構成（炎ボタン専用 + 統計画面）
2. **ナビゲーション**: 画面間移動の仕組み追加
3. **スワイプ点火**: 炎の段階的点火アニメーション
4. **操作ガイド**: アニメーション付きガイダンス
5. **バイブレーション**: 触覚フィードバック
6. **自動画面遷移**: 記録完了後の自動移動

## 実装戦略

### フェーズ1: 基盤準備（1-2時間）
1. **依存関係追加**
   - `vibration` または `haptic_feedback` パッケージ
   - ナビゲーション用の追加パッケージ（必要に応じて）

2. **画面構成変更**
   - `main.dart`でナビゲーション構造に変更
   - 現在の`MyHomePage`を2つの画面に分割

### フェーズ2: 炎ボタン画面実装（2-3時間）
1. **新しい炎ボタン画面作成**
   - スワイプ検出機能
   - 段階的炎点火アニメーション
   - 操作ガイドアニメーション

2. **スワイプアニメーション実装**
   - 炎の色変化エフェクト
   - 下から上への進行表示

### フェーズ3: 統計画面実装（1時間）
1. **統計画面作成**
   - 既存ウィジェット（連続記録日数、カレンダー）を移動
   - レイアウト調整

### フェーズ4: ナビゲーション統合（1時間）
1. **画面間遷移実装**
   - ナビゲーションバー追加
   - 自動画面遷移機能

### フェーズ5: 最終調整（30分）
1. **ポップなデザイン調整**
2. **パフォーマンス最適化**
3. **テスト実行**

## 詳細実装計画

### 1. ファイル構成変更

**新規作成ファイル:**
```
lib/
├── screens/
│   ├── flame_record_screen.dart     # 炎ボタン専用画面
│   └── statistics_screen.dart       # 統計表示画面
├── widgets/
│   ├── flame_ignition_widget.dart   # 新しい炎点火ウィジェット
│   └── swipe_guide_animation.dart   # 操作ガイドアニメーション
└── navigation/
    └── app_navigation.dart          # ナビゲーション管理
```

**既存ファイル変更:**
- `main.dart`: ナビゲーション構造への変更
- `my_homepage.dart`: 機能分割とリファクタリング
- `pubspec.yaml`: 依存関係追加

### 2. 炎点火アニメーション実装詳細

**技術アプローチ:**
```dart
class FlameIgnitionWidget extends StatefulWidget {
  @override
  _FlameIgnitionWidgetState createState() => _FlameIgnitionWidgetState();
}

class _FlameIgnitionWidgetState extends State<FlameIgnitionWidget>
    with TickerProviderStateMixin {
  
  late AnimationController _ignitionController;
  late Animation<double> _ignitionProgress;
  late AnimationController _guideController;
  
  double _swipeProgress = 0.0;  // 0.0 → 1.0
  bool _isSwipeActive = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onSwipeStart,
      onPanUpdate: _onSwipeUpdate,
      onPanEnd: _onSwipeEnd,
      child: Stack(
        children: [
          _buildFlameIcon(),
          if (!_isSwipeActive) _buildSwipeGuide(),
        ],
      ),
    );
  }
  
  Widget _buildFlameIcon() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            _getFlameColor(_swipeProgress),
            Colors.transparent,
          ],
          stops: [_swipeProgress, _swipeProgress],
        ).createShader(bounds);
      },
      child: Icon(
        Icons.local_fire_department,
        size: 100,
        color: _swipeProgress > 0 ? Colors.orange : Colors.grey[400],
      ),
    );
  }
}
```

### 3. 画面遷移設計

**ナビゲーション構造:**
```dart
class AppNavigation extends StatefulWidget {
  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    FlameRecordScreen(),
    StatisticsScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
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
```

### 4. バイブレーション実装

**パッケージ選択:**
- `haptic_feedback`（軽量、推奨）
- 実装場所: 炎点火完了時

```dart
import 'package:flutter/services.dart';

void _onIgnitionComplete() {
  HapticFeedback.mediumImpact();  // バイブレーション
  // 記録処理
  // 自動画面遷移
}
```

## リスク要因と対策

### 1. アニメーション性能
**リスク**: 複雑なアニメーションによる性能劣化
**対策**: シンプルな実装から開始、必要に応じて最適化

### 2. スワイプ操作の使いやすさ
**リスク**: 操作が直感的でない可能性
**対策**: 操作ガイドアニメーションを目立たせる、感度調整

### 3. 既存機能への影響
**リスク**: リファクタリングによる既存機能の破損
**対策**: 段階的実装、各フェーズでのテスト実行

## 成功指標

1. **機能実装完了**: 全要件の技術的実現
2. **操作性向上**: スワイプ操作の直感性
3. **視覚的魅力**: Duolingoライクなポップさ
4. **パフォーマンス維持**: 既存レスポンス性能の維持

## 開発開始準備

現在のコードベースは実装に十分適しており、既存の高品質なアーキテクチャを活用して効率的に開発できます。特にデザインシステムとアニメーション基盤が優秀なため、スムーズな実装が期待できます。
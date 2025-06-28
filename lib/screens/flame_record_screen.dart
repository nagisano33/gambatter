import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database_helper.dart';
import '../theme/theme_provider.dart';
import '../widgets/flame_ignition_widget.dart';
import '../widgets/swipe_guide_animation.dart';

class FlameRecordScreen extends StatefulWidget {
  const FlameRecordScreen({
    super.key,
    required this.onRecordCompleted,
  });

  final VoidCallback onRecordCompleted;

  @override
  State<FlameRecordScreen> createState() => _FlameRecordScreenState();
}

class _FlameRecordScreenState extends State<FlameRecordScreen> {
  final dbHelper = DatabaseHelper.instance;

  bool _isRecordedToday = false;
  bool _isLoading = false;
  double _swipeProgress = 0.0; // 0.0 → 1.0

  @override
  void initState() {
    super.initState();
    _checkTodayRecord();
  }

  Future<void> _checkTodayRecord() async {
    final today = DateTime.now();
    final isRecorded = await dbHelper.hasEffortRecordForDate(today);
    setState(() {
      _isRecordedToday = isRecorded;
    });
  }

  void _onProgressChanged(double progress) {
    setState(() {
      _swipeProgress = progress;
    });
  }

  void _onSwipeStart(DragStartDetails details) {
    if (_isRecordedToday || _isLoading) return;
    
    setState(() {
      _swipeProgress = 0.0;
    });
  }

  void _onSwipeUpdate(DragUpdateDetails details) {
    if (_isRecordedToday || _isLoading) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    // 画面の下部から上部への進行度を計算
    final progress = 1.0 - (localPosition.dy / size.height);
    final clampedProgress = progress.clamp(0.0, 1.0);

    _onProgressChanged(clampedProgress);

    // 完了判定（70%以上で点火完了）
    if (clampedProgress >= 0.7) {
      _onIgnitionComplete();
    }
  }

  void _onSwipeEnd(DragEndDetails details) {
    if (_isRecordedToday || _isLoading) return;

    // 完了していない場合は元に戻す
    if (_swipeProgress < 0.7) {
      setState(() {
        _swipeProgress = 0.0;
      });
    }
  }

  Future<void> _onIgnitionComplete() async {
    if (_isRecordedToday || _isLoading) return;

    setState(() {
      _isLoading = true;
      _swipeProgress = 1.0;
    });

    try {
      final today = DateTime.now();
      
      // 重複チェック
      final alreadyRecorded = await dbHelper.hasEffortRecordForDate(today);
      if (alreadyRecorded) {
        setState(() {
          _isRecordedToday = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('今日はすでに記録済みです'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // ハプティックフィードバックは FlameIgnitionWidget で処理

      await dbHelper.insertEffortRecord(today);

      setState(() {
        _isRecordedToday = true;
      });

      // 少し待ってから自動画面遷移
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (mounted) {
        widget.onRecordCompleted();
      }
    } catch (e) {
      print('記録エラー: $e'); // デバッグ用ログ
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('記録に失敗しました: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
        setState(() {
          _swipeProgress = 0.0;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final tokens = context.designTokens;

    return Scaffold(
      appBar: AppBar(
        title: const Text('頑張りを記録'),
        automaticallyImplyLeading: false, // 戻るボタンを非表示
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 背景グラデーション
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  tokens.surface,
                  tokens.surfaceVariant.withOpacity(0.3),
                  tokens.surface,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          
          // スワイプ検出エリア（画面全体）
          GestureDetector(
            onPanStart: _onSwipeStart,
            onPanUpdate: _onSwipeUpdate,
            onPanEnd: _onSwipeEnd,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              child: SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    
                    // 炎ウィジェット（表示のみ）
                    Expanded(
                      flex: 3,
                      child: FlameIgnitionWidget(
                        onProgressChanged: _onProgressChanged,
                        onIgnitionComplete: _onIgnitionComplete,
                        isRecordedToday: _isRecordedToday,
                        isLoading: _isLoading,
                        enableGestures: false, // ジェスチャーを無効化
                        swipeProgress: _swipeProgress, // 進行度を渡す
                      ),
                    ),
                
                    
                    SizedBox(height: tokens.spacingXl),
                    
                    // 状態表示
                    if (_isRecordedToday)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: tokens.spacingLg),
                        padding: EdgeInsets.symmetric(
                          horizontal: tokens.spacingLg,
                          vertical: tokens.spacingMd,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade50,
                              Colors.green.shade100,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(tokens.radiusLg),
                          border: Border.all(
                            color: Colors.green.shade300,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.shade200.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade700,
                              size: 24,
                            ),
                            SizedBox(width: tokens.spacingSm),
                            Text(
                              '今日の頑張りを記録しました！',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: tokens.fontSizeMd,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (_isLoading)
                      Container(
                        padding: EdgeInsets.all(tokens.spacingLg),
                        child: const CircularProgressIndicator(),
                      )
                    else
                      // スワイプガイドアニメーション
                      SwipeGuideAnimation(
                        isVisible: !_isRecordedToday && !_isLoading,
                        isSwipeActive: _swipeProgress > 0.0,
                      ),
                    
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: kDebugMode
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isRecordedToday = !_isRecordedToday;
                });
              },
              backgroundColor: Theme.of(context).colorScheme.error,
              child: const Icon(Icons.refresh),
            )
          : null,
    );
  }
}
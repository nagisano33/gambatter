import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database_helper.dart';
import '../theme/theme_provider.dart';

class FlameRecordScreen extends StatefulWidget {
  const FlameRecordScreen({
    super.key,
    required this.onRecordCompleted,
  });

  final VoidCallback onRecordCompleted;

  @override
  State<FlameRecordScreen> createState() => _FlameRecordScreenState();
}

class _FlameRecordScreenState extends State<FlameRecordScreen>
    with TickerProviderStateMixin {
  final dbHelper = DatabaseHelper.instance;

  bool _isRecordedToday = false;
  bool _isLoading = false;
  double _swipeProgress = 0.0; // 0.0 → 1.0
  bool _isSwipeActive = false;

  late AnimationController _guideController;
  late Animation<double> _guideOpacity;
  late Animation<Offset> _guideOffset;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkTodayRecord();
  }

  void _initializeAnimations() {
    _guideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _guideOpacity = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _guideController,
        curve: Curves.easeInOut,
      ),
    );

    _guideOffset = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: const Offset(0, -0.3),
    ).animate(
      CurvedAnimation(
        parent: _guideController,
        curve: Curves.easeInOut,
      ),
    );

    _guideController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _guideController.dispose();
    super.dispose();
  }

  Future<void> _checkTodayRecord() async {
    final today = DateTime.now();
    final isRecorded = await dbHelper.hasEffortRecordForDate(today);
    setState(() {
      _isRecordedToday = isRecorded;
    });
  }

  void _onSwipeStart(DragStartDetails details) {
    if (_isRecordedToday || _isLoading) return;

    setState(() {
      _isSwipeActive = true;
      _swipeProgress = 0.0;
    });
  }

  void _onSwipeUpdate(DragUpdateDetails details) {
    if (_isRecordedToday || _isLoading || !_isSwipeActive) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    // 画面の下部から上部への進行度を計算
    final progress = 1.0 - (localPosition.dy / size.height);
    final clampedProgress = progress.clamp(0.0, 1.0);

    setState(() {
      _swipeProgress = clampedProgress;
    });

    // 完了判定（50%以上で点火完了に変更してテストしやすく）
    if (clampedProgress >= 0.5) {
      _onIgnitionComplete();
    }
  }

  void _onSwipeEnd(DragEndDetails details) {
    if (_isRecordedToday || _isLoading) return;

    // 完了していない場合は元に戻す
    if (_swipeProgress < 0.5) {
      setState(() {
        _swipeProgress = 0.0;
        _isSwipeActive = false;
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

      // ハプティックフィードバック（エミュレータ対応）
      HapticFeedback.mediumImpact();

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
          _isSwipeActive = false;
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

  Color _getFlameColor(double progress) {
    if (progress >= 0.5) {
      return Colors.red.shade600; // 完了時の赤
    } else if (progress >= 0.3) {
      return Color.lerp(Colors.orange.shade400, Colors.red.shade600, (progress - 0.3) * 5) ?? Colors.orange;
    } else if (progress >= 0.1) {
      return Color.lerp(Colors.yellow.shade600, Colors.orange.shade400, (progress - 0.1) * 5) ?? Colors.yellow;
    } else if (progress > 0) {
      return Color.lerp(Colors.grey.shade400, Colors.yellow.shade600, progress * 10) ?? Colors.grey;
    } else {
      return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.designTokens;

    return Scaffold(
      appBar: AppBar(
        title: const Text('頑張りを記録'),
        automaticallyImplyLeading: false, // 戻るボタンを非表示
      ),
      body: GestureDetector(
        onPanStart: _onSwipeStart,
        onPanUpdate: _onSwipeUpdate,
        onPanEnd: _onSwipeEnd,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              // 炎アイコン
              Stack(
                alignment: Alignment.center,
                children: [
                  // 炎の輪郭
                  Icon(
                    Icons.local_fire_department,
                    size: 120,
                    color: Colors.grey.shade300,
                  ),
                  // 段階的に色づく炎
                  ClipRect(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      heightFactor: _swipeProgress,
                      child: Icon(
                        Icons.local_fire_department,
                        size: 120,
                        color: _getFlameColor(_swipeProgress),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: tokens.spacingXl),

              // 状態表示
              if (_isRecordedToday)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: tokens.spacingLg,
                    vertical: tokens.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(tokens.radiusMd),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green.shade700,
                        size: 20,
                      ),
                      SizedBox(width: tokens.spacingSm),
                      Text(
                        '今日の頑張りを記録しました！',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              else if (_isLoading)
                const CircularProgressIndicator()
              else
                // 操作ガイド
                AnimatedBuilder(
                  animation: _guideController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _isSwipeActive ? 0.0 : _guideOpacity.value,
                      child: Transform.translate(
                        offset: _guideOffset.value * 20,
                        child: Column(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_up,
                              size: 32,
                              color: tokens.onSurfaceVariant,
                            ),
                            SizedBox(height: tokens.spacingSm),
                            Text(
                              'スワイプして記録しよう',
                              style: TextStyle(
                                fontSize: tokens.fontSizeLg,
                                color: tokens.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              const Spacer(flex: 3),
            ],
          ),
        ),
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
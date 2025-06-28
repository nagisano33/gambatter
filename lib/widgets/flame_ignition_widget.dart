import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';

class FlameIgnitionWidget extends StatefulWidget {
  final Function(double) onProgressChanged;
  final VoidCallback? onIgnitionComplete;
  final bool isRecordedToday;
  final bool isLoading;
  final bool enableGestures;
  final double swipeProgress; // 外部から進行度を受け取る

  const FlameIgnitionWidget({
    super.key,
    required this.onProgressChanged,
    this.onIgnitionComplete,
    this.isRecordedToday = false,
    this.isLoading = false,
    this.enableGestures = true,
    this.swipeProgress = 0.0,
  });

  @override
  State<FlameIgnitionWidget> createState() => _FlameIgnitionWidgetState();
}

class _FlameIgnitionWidgetState extends State<FlameIgnitionWidget>
    with TickerProviderStateMixin {
  bool _isSwipeActive = false;
  bool _isIgnited = false;

  // 外部から受け取った進行度を使用
  double get _swipeProgress => widget.swipeProgress;

  late AnimationController _flickerController;
  late AnimationController _glowController;
  late AnimationController _scaleController;
  
  late Animation<double> _flickerOpacity;
  late Animation<double> _glowIntensity;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // 炎のちらつきアニメーション
    _flickerController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _flickerOpacity = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flickerController,
      curve: Curves.easeInOut,
    ));

    // 発光エフェクト
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _glowIntensity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeOut,
    ));

    // スケールアニメーション
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _flickerController.dispose();
    _glowController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onSwipeStart(DragStartDetails details) {
    if (widget.isRecordedToday || widget.isLoading) return;

    setState(() {
      _isSwipeActive = true;
      _isIgnited = false;
    });
    
    _flickerController.repeat(reverse: true);
  }

  void _onSwipeUpdate(DragUpdateDetails details) {
    // スワイプ更新は親コンポーネントで処理
    // 70%以上で点火完了判定
    if (_swipeProgress >= 0.7 && !_isIgnited) {
      _triggerIgnition();
    }
  }

  void _onSwipeEnd(DragEndDetails details) {
    if (widget.isRecordedToday || widget.isLoading) return;

    // 完了していない場合は元に戻す
    if (_swipeProgress < 0.7) {
      setState(() {
        _isSwipeActive = false;
        _isIgnited = false;
      });
      _flickerController.stop();
      _glowController.reset();
      _scaleController.reset();
    }
  }

  void _triggerIgnition() {
    if (_isIgnited) return;
    
    setState(() {
      _isIgnited = true;
    });

    _flickerController.stop();
    _glowController.forward();
    _scaleController.forward();

    // ハプティックフィードバック
    HapticFeedback.mediumImpact();

    // 完了コールバック
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onIgnitionComplete?.call();
    });
  }

  Color _getFlameColor(double progress) {
    if (_isIgnited || progress >= 0.7) {
      return Colors.red.shade600; // 完了時の赤
    } else if (progress >= 0.5) {
      return Color.lerp(
        Colors.orange.shade400,
        Colors.red.shade600,
        (progress - 0.5) * 5,
      ) ?? Colors.orange;
    } else if (progress >= 0.2) {
      return Color.lerp(
        Colors.yellow.shade600,
        Colors.orange.shade400,
        (progress - 0.2) * 3.33,
      ) ?? Colors.yellow;
    } else if (progress > 0) {
      return Color.lerp(
        Colors.grey.shade400,
        Colors.yellow.shade600,
        progress * 5,
      ) ?? Colors.grey;
    } else {
      return Colors.grey.shade400;
    }
  }

  Widget _buildFlameIcon() {
    final tokens = context.designTokens;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_flickerController, _glowController, _scaleController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: _isIgnited ? BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: _getFlameColor(_swipeProgress).withOpacity(_glowIntensity.value * 0.6),
                  blurRadius: 30 * _glowIntensity.value,
                  spreadRadius: 10 * _glowIntensity.value,
                ),
              ],
            ) : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 背景の炎（輪郭）
                Icon(
                  Icons.local_fire_department,
                  size: 140,
                  color: tokens.onSurfaceVariant.withOpacity(0.3),
                ),
                // メインの炎（段階的点火）
                ClipRect(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: _swipeProgress,
                    child: Opacity(
                      opacity: _isSwipeActive ? _flickerOpacity.value : 1.0,
                      child: Icon(
                        Icons.local_fire_department,
                        size: 140,
                        color: _getFlameColor(_swipeProgress),
                      ),
                    ),
                  ),
                ),
                // 発光エフェクト
                if (_isIgnited)
                  Opacity(
                    opacity: _glowIntensity.value * 0.4,
                    child: Icon(
                      Icons.local_fire_department,
                      size: 140,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: Center(
        child: _buildFlameIcon(),
      ),
    );

    if (widget.enableGestures) {
      return GestureDetector(
        onPanStart: _onSwipeStart,
        onPanUpdate: _onSwipeUpdate,
        onPanEnd: _onSwipeEnd,
        child: child,
      );
    } else {
      return child;
    }
  }
}
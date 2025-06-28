import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';

class SwipeGuideAnimation extends StatefulWidget {
  final bool isVisible;
  final bool isSwipeActive;

  const SwipeGuideAnimation({
    super.key,
    required this.isVisible,
    required this.isSwipeActive,
  });

  @override
  State<SwipeGuideAnimation> createState() => _SwipeGuideAnimationState();
}

class _SwipeGuideAnimationState extends State<SwipeGuideAnimation>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;

  late Animation<Offset> _bounceAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // バウンスアニメーション（上下移動）
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _bounceAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: const Offset(0, -0.3),
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    // フェードアニメーション
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // パルスアニメーション（矢印の強調）
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    if (widget.isVisible && !widget.isSwipeActive) {
      _bounceController.repeat(reverse: true);
      _fadeController.repeat(reverse: true);
      _pulseController.repeat(reverse: true);
    }
  }

  void _stopAnimations() {
    _bounceController.stop();
    _fadeController.stop();
    _pulseController.stop();
  }

  @override
  void didUpdateWidget(SwipeGuideAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isVisible && !widget.isSwipeActive) {
      _startAnimations();
    } else {
      _stopAnimations();
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.designTokens;

    if (!widget.isVisible || widget.isSwipeActive) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_bounceController, _fadeController, _pulseController]),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value * 0.8,
          child: Transform.translate(
            offset: _bounceAnimation.value * 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // アニメーション付き矢印
                Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    size: 40,
                    color: tokens.primary,
                  ),
                ),
                
                SizedBox(height: tokens.spacingSm),
                
                // テキストガイド
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app,
                      size: 18,
                      color: tokens.primary,
                    ),
                    SizedBox(width: tokens.spacingXs),
                    Text(
                      'スワイプして記録しよう',
                      style: TextStyle(
                        fontSize: tokens.fontSizeMd,
                        color: tokens.primary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: tokens.spacingXs),
                
                // プログレスバー風の装飾
                Container(
                  width: 120,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(tokens.radiusXs),
                    gradient: LinearGradient(
                      colors: [
                        tokens.primary.withOpacity(0.3),
                        tokens.primary.withOpacity(0.7),
                        tokens.primary.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
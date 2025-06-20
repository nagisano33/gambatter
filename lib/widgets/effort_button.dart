import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';

class EffortButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isRecordedToday;
  final bool isLoading;

  const EffortButton({
    super.key,
    required this.onPressed,
    required this.isRecordedToday,
    this.isLoading = false,
  });

  @override
  State<EffortButton> createState() => _EffortButtonState();
}

class _EffortButtonState extends State<EffortButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isRecordedToday || widget.isLoading) return;
    
    _animationController.forward().then((_) {
      _animationController.reverse();
      widget.onPressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.designTokens;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacingXl, 
        vertical: tokens.spacingMd,
      ),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: SizedBox(
              width: double.infinity,
              height: tokens.buttonHeight,
              child: ElevatedButton(
                onPressed: _handleTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isRecordedToday
                      ? Theme.of(context).colorScheme.surfaceVariant
                      : Theme.of(context).colorScheme.primary,
                  foregroundColor: widget.isRecordedToday
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(tokens.radiusLg),
                  ),
                  elevation: widget.isRecordedToday ? 0 : 4,
                ),
                child: widget.isLoading
                    ? SizedBox(
                        width: tokens.spacingLg,
                        height: tokens.spacingLg,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.isRecordedToday
                                ? Icons.check_circle
                                : Icons.favorite,
                            size: tokens.fontSizeXxl,
                          ),
                          SizedBox(width: tokens.spacingSm + tokens.spacingXs),
                          Text(
                            widget.isRecordedToday
                                ? '今日は頑張りました！'
                                : '今日も頑張った！',
                            style: TextStyle(
                              fontSize: tokens.fontSizeLg,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
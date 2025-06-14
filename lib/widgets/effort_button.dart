import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: SizedBox(
              width: double.infinity,
              height: 80,
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
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: widget.isRecordedToday ? 0 : 4,
                ),
                child: widget.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
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
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.isRecordedToday
                                ? '今日は頑張りました！'
                                : '今日も頑張った！',
                            style: const TextStyle(
                              fontSize: 18,
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
import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';

class ConsecutiveDaysDisplay extends StatelessWidget {
  final int consecutiveDays;

  const ConsecutiveDaysDisplay({
    super.key,
    required this.consecutiveDays,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.designTokens;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: tokens.spacingLg, 
        horizontal: tokens.spacingMd,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: tokens.spacingMd, 
        vertical: tokens.spacingSm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(tokens.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_fire_department,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: tokens.fontSizeXxl,
          ),
          SizedBox(width: tokens.spacingSm + tokens.spacingXs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '連続記録',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                '$consecutiveDays日',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Key metrics card displaying business performance indicators
/// Shows value, label, percentage change, and trend indicator
class MetricsCardWidget extends StatelessWidget {
  final String label;
  final String value;
  final String percentageChange;
  final bool isPositive;
  final IconData icon;

  const MetricsCardWidget({
    super.key,
    required this.label,
    required this.value,
    required this.percentageChange,
    required this.isPositive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: icon
                      .toString()
                      .split('.')
                      .last
                      .replaceAll('IconData(U+', '')
                      .replaceAll(')', ''),
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppTheme.successLight.withValues(alpha: 0.1)
                      : AppTheme.errorLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: isPositive ? 'trending_up' : 'trending_down',
                      size: 14,
                      color: isPositive
                          ? AppTheme.successLight
                          : AppTheme.errorLight,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      percentageChange,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isPositive
                            ? AppTheme.successLight
                            : AppTheme.errorLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

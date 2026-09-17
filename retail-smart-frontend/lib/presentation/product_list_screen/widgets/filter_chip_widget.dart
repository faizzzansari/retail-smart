import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.15),
            theme.colorScheme.primary.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(width: 1.5.w),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: EdgeInsets.all(0.5.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: theme.colorScheme.primary,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

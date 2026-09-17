import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Date range selector widget with quick selection buttons
/// Provides Daily, Weekly, Monthly views and custom range picker
class DateRangeSelectorWidget extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;
  final VoidCallback onCustomRangePressed;

  const DateRangeSelectorWidget({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.onCustomRangePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Period',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildPeriodButton(
                  context,
                  'Daily',
                  selectedPeriod == 'Daily',
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildPeriodButton(
                  context,
                  'Weekly',
                  selectedPeriod == 'Weekly',
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildPeriodButton(
                  context,
                  'Monthly',
                  selectedPeriod == 'Monthly',
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onCustomRangePressed,
              icon: CustomIconWidget(
                iconName: 'calendar_today',
                size: 18,
                color: theme.colorScheme.primary,
              ),
              label: Text('Custom Range'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(
    BuildContext context,
    String period,
    bool isSelected,
  ) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: () => onPeriodChanged(period),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.surface,
        foregroundColor: isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        elevation: isSelected ? 2 : 0,
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Text(
        period,
        style: theme.textTheme.labelLarge?.copyWith(
          color: isSelected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

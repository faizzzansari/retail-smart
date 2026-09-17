import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Stock alerts section highlighting low inventory items
/// Provides quick access to restock functionality
class StockAlertsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> lowStockItems;
  final VoidCallback onRestockPressed;

  const StockAlertsWidget({
    super.key,
    required this.lowStockItems,
    required this.onRestockPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (lowStockItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  size: 20,
                  color: AppTheme.warningLight,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Low Stock Alerts',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lowStockItems.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final item = lowStockItems[index];
              return _buildAlertCard(context, item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.warningLight.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.warningLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.warningLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'inventory_2',
              size: 24,
              color: AppTheme.warningLight,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["name"] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Only ${item["stock"]} units remaining',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.warningLight,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onRestockPressed,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              side: BorderSide(color: theme.colorScheme.primary),
            ),
            child: Text('Restock', style: theme.textTheme.labelSmall),
          ),
        ],
      ),
    );
  }
}

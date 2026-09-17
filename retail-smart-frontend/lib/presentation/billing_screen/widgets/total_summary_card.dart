import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Total summary card displaying running total and tax breakdown
class TotalSummaryCard extends StatelessWidget {
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double grandTotal;

  const TotalSummaryCard({
    super.key,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            _buildSummaryRow(
              context,
              'Subtotal',
              subtotal,
              theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 1.h),
            _buildSummaryRow(
              context,
              'Tax (8%)',
              taxAmount,
              theme.textTheme.bodyMedium,
            ),
            if (discountAmount > 0) ...[
              SizedBox(height: 1.h),
              _buildSummaryRow(
                context,
                'Discount',
                -discountAmount,
                theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.successLight,
                ),
              ),
            ],
            Divider(height: 3.h, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  '₹${grandTotal.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    double amount,
    TextStyle? style,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          '₹${amount.abs().toStringAsFixed(2)}',
          style: style?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

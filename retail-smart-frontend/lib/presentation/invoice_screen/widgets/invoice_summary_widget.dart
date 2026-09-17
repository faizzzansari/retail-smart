import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Invoice Summary Widget - Financial calculations summary
///
/// Displays:
/// - Subtotal
/// - Tax calculations
/// - Discounts applied
/// - Final total with prominent typography
class InvoiceSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double taxRate;
  final double taxAmount;
  final double discount;
  final double total;

  const InvoiceSummaryWidget({
    super.key,
    required this.subtotal,
    required this.taxRate,
    required this.taxAmount,
    required this.discount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Column(
        children: [
          // Subtotal row
          _buildSummaryRow(
            context: context,
            label: 'Subtotal',
            value: '₹${subtotal.toStringAsFixed(2)}',
            isRegular: true,
          ),

          SizedBox(height: 1.h),

          // Tax row
          _buildSummaryRow(
            context: context,
            label: 'Tax (${(taxRate * 100).toStringAsFixed(0)}%)',
            value: '₹${taxAmount.toStringAsFixed(2)}',
            isRegular: true,
          ),

          SizedBox(height: 1.h),

          // Discount row
          _buildSummaryRow(
            context: context,
            label: 'Discount',
            value: '-₹${discount.toStringAsFixed(2)}',
            isRegular: true,
            valueColor: theme.colorScheme.tertiary,
          ),

          SizedBox(height: 1.h),

          Divider(color: theme.colorScheme.outline, thickness: 1),

          SizedBox(height: 1.h),

          // Total row with prominent styling
          _buildSummaryRow(
            context: context,
            label: 'Total',
            value: '₹${total.toStringAsFixed(2)}',
            isRegular: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required BuildContext context,
    required String label,
    required String value,
    required bool isRegular,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isRegular
              ? theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                )
              : theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
        ),
        Text(
          value,
          style: isRegular
              ? theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? theme.colorScheme.onSurface,
                )
              : theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
        ),
      ],
    );
  }
}

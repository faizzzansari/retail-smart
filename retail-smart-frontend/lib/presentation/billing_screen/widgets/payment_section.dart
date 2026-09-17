import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Payment method selection and discount section
class PaymentSection extends StatelessWidget {
  final String selectedPaymentMethod;
  final Function(String) onPaymentMethodChanged;
  final TextEditingController amountTenderedController;
  final String discountType;
  final Function(String) onDiscountTypeChanged;
  final TextEditingController discountController;
  final String? discountReason;
  final Function(String?) onDiscountReasonChanged;

  const PaymentSection({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
    required this.amountTenderedController,
    required this.discountType,
    required this.onDiscountTypeChanged,
    required this.discountController,
    required this.discountReason,
    required this.onDiscountReasonChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: [
                _buildPaymentChip(context, 'Cash', 'payments'),
                _buildPaymentChip(context, 'Card', 'credit_card'),
                _buildPaymentChip(context, 'Digital', 'qr_code_scanner'),
              ],
            ),
            if (selectedPaymentMethod == 'Cash') ...[
              SizedBox(height: 2.h),
              TextField(
                controller: amountTenderedController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount Tendered',
                  hintText: 'Enter amount received',
                  prefixText: '₹ ',
                ),
              ),
            ],
            SizedBox(height: 3.h),
            Text(
              'Discount',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'percentage',
                        label: Text('%'),
                        icon: Icon(Icons.percent),
                      ),
                      ButtonSegment(
                        value: 'fixed',
                        label: Text('₹'),
                        icon: Icon(Icons.attach_money),
                      ),
                    ],
                    selected: {discountType},
                    onSelectionChanged: (Set<String> newSelection) {
                      onDiscountTypeChanged(newSelection.first);
                    },
                  ),
                ),
                SizedBox(width: 2.w),
                SizedBox(
                  width: 30.w,
                  child: TextField(
                    controller: discountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: discountType == 'percentage' ? '0' : '0.00',
                      prefixText: discountType == 'percentage' ? '' : '₹ ',
                      suffixText: discountType == 'percentage' ? '%' : '',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            DropdownButtonFormField<String>(
              initialValue: discountReason,
              decoration: const InputDecoration(
                labelText: 'Discount Reason',
                hintText: 'Select reason',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Loyalty',
                  child: Text('Loyalty Discount'),
                ),
                DropdownMenuItem(
                  value: 'Promotion',
                  child: Text('Promotional Offer'),
                ),
                DropdownMenuItem(value: 'Bulk', child: Text('Bulk Purchase')),
                DropdownMenuItem(
                  value: 'Clearance',
                  child: Text('Clearance Sale'),
                ),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: onDiscountReasonChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentChip(
    BuildContext context,
    String label,
    String iconName,
  ) {
    final theme = Theme.of(context);
    final isSelected = selectedPaymentMethod == label;

    return FilterChip(
      label: Text(label),
      avatar: CustomIconWidget(
        iconName: iconName,
        color: isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurfaceVariant,
        size: 18,
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          onPaymentMethodChanged(label);
        }
      },
      selectedColor: theme.colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }
}

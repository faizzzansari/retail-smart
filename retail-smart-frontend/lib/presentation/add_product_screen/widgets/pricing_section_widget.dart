import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PricingSectionWidget extends StatelessWidget {
  final TextEditingController costPriceController;
  final TextEditingController sellingPriceController;
  final double marginPercentage;

  const PricingSectionWidget({
    super.key,
    required this.costPriceController,
    required this.sellingPriceController,
    required this.marginPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pricing',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          TextFormField(
            controller: costPriceController,
            decoration: InputDecoration(
              labelText: 'Cost Price *',
              hintText: '0.00',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'attach_money',
                  size: 5.w,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Cost price is required';
              }
              final price = double.tryParse(value);
              if (price == null || price < 0) {
                return 'Enter a valid price';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),
          TextFormField(
            controller: sellingPriceController,
            decoration: InputDecoration(
              labelText: 'Selling Price *',
              hintText: '0.00',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'sell',
                  size: 5.w,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Selling price is required';
              }
              final price = double.tryParse(value);
              if (price == null || price < 0) {
                return 'Enter a valid price';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: marginPercentage >= 0
                  ? theme.colorScheme.tertiaryContainer
                  : theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: marginPercentage >= 0
                      ? 'trending_up'
                      : 'trending_down',
                  size: 5.w,
                  color: marginPercentage >= 0
                      ? theme.colorScheme.onTertiaryContainer
                      : theme.colorScheme.onErrorContainer,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Margin: ${marginPercentage.toStringAsFixed(1)}%',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: marginPercentage >= 0
                        ? theme.colorScheme.onTertiaryContainer
                        : theme.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

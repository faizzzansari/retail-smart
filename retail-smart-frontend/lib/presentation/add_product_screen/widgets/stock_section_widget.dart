import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class StockSectionWidget extends StatelessWidget {
  final TextEditingController quantityController;
  final TextEditingController minStockController;
  final Function(int) onAdjustQuantity;

  const StockSectionWidget({
    super.key,
    required this.quantityController,
    required this.minStockController,
    required this.onAdjustQuantity,
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
            'Stock Management',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Current Quantity',
                    hintText: '0',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'inventory_2',
                        size: 5.w,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              SizedBox(width: 3.w),
              Column(
                children: [
                  IconButton(
                    onPressed: () => onAdjustQuantity(1),
                    icon: CustomIconWidget(
                      iconName: 'add_circle',
                      size: 8.w,
                      color: theme.colorScheme.primary,
                    ),
                    tooltip: 'Increase quantity',
                  ),
                  IconButton(
                    onPressed: () => onAdjustQuantity(-1),
                    icon: CustomIconWidget(
                      iconName: 'remove_circle',
                      size: 8.w,
                      color: theme.colorScheme.error,
                    ),
                    tooltip: 'Decrease quantity',
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          TextFormField(
            controller: minStockController,
            decoration: InputDecoration(
              labelText: 'Minimum Stock Alert',
              hintText: '5',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'notifications_active',
                  size: 5.w,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
    );
  }
}

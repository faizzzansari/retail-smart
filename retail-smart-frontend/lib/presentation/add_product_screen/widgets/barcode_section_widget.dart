import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BarcodeSectionWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onScanPressed;

  const BarcodeSectionWidget({
    super.key,
    required this.controller,
    required this.onScanPressed,
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
            'Barcode',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Barcode Number',
                    hintText: 'Enter or scan barcode',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'qr_code',
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
              ElevatedButton(
                onPressed: onScanPressed,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'qr_code_scanner',
                  size: 6.w,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

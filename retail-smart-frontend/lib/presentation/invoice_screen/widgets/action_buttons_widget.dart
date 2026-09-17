import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Action Buttons Widget - Post-invoice actions
///
/// Features:
/// - New Sale button (returns to BillingScreen)
/// - Save Customer button (stores customer details)
/// - Mobile-optimized button layout
class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onNewSale;
  final VoidCallback onSaveCustomer;

  const ActionButtonsWidget({
    super.key,
    required this.onNewSale,
    required this.onSaveCustomer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          // New Sale button (primary action)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNewSale,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'add_shopping_cart',
                    color: theme.colorScheme.onPrimary,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'New Sale',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Save Customer button (secondary action)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onSaveCustomer,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'person_add',
                    color: theme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Save Customer',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

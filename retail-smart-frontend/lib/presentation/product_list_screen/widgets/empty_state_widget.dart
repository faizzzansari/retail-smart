import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'inventory_2',
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              "No Products Found",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              "Start building your inventory by adding your first product",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed('/add-product-screen');
              },
              icon: CustomIconWidget(
                iconName: 'add',
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
              label: const Text("Add Your First Product"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

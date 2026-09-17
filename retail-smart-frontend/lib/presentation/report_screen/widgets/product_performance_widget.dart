import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Product performance section listing top sellers
/// Shows product details with revenue contribution
class ProductPerformanceWidget extends StatelessWidget {
  final List<Map<String, dynamic>> topProducts;

  const ProductPerformanceWidget({super.key, required this.topProducts});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (topProducts.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        padding: EdgeInsets.all(4.w),
        child: Center(
          child: Text(
            "No Top Products Found",
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Selling Products',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.home);
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: topProducts.length,
            separatorBuilder: (_, __) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final product = topProducts[index];
              return _buildProductCard(context, product);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    final theme = Theme.of(context);

    final String imageUrl = product["image"]?.toString() ?? "";

    final String name = product["name"]?.toString() ?? "Unknown Product";

    final int quantity = (product["quantity"] is num)
        ? (product["quantity"] as num).toInt()
        : 0;

    final String revenue = product["revenue"]?.toString() ?? "₹0";

    final int contribution = (product["contribution"] is num)
        ? (product["contribution"] as num).toInt()
        : 0;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          /// ---------- IMAGE SECTION ----------
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.colorScheme.surfaceContainerHighest,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported),
                    )
                  : const Icon(Icons.image_not_supported),
            ),
          ),

          SizedBox(width: 3.w),

          /// ---------- TEXT SECTION ----------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '$quantity units sold',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      revenue,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$contribution%',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.successLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          CustomIconWidget(
            iconName: 'chevron_right',
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

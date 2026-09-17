import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onTap,
    required this.onLongPress,
    required this.onDelete,
    required this.onEdit,
  });

  Color _getStockStatusColor(int stock, int minStock) {
    if (stock < minStock) {
      return const Color(0xFFEF4444);
    }
    return const Color(0xFF10B981);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ✅ SAFE DATA EXTRACTION FROM BACKEND
    final String id = product["id"] ?? "";
    final String name = product["name"] ?? "";
    final String sku = product["sku"] ?? "";
    final String imageUrl =
        product["image_url"] ?? "https://via.placeholder.com/150";

    final int stock = product["stock"] ?? 0;
    final int minStock = product["minimum_stock_alert"] ?? 0;

    final double price = (product["selling_price"] ?? 0).toDouble();

    final stockColor = _getStockStatusColor(stock, minStock);

    return Slidable(
      key: ValueKey(id),
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onEdit(),
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            icon: Icons.edit_rounded,
            label: 'Edit',
            borderRadius: BorderRadius.circular(16),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onDelete(),
            backgroundColor: const Color(0xFFEF4444),
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: BorderRadius.circular(16),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(3.5.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// PRODUCT IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: 22.w,
                    height: 22.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 22.w,
                        height: 22.w,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),

                SizedBox(width: 3.5.w),

                /// PRODUCT DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// NAME
                      Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                          color: const Color(0xFF1E293B),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 0.6.h),

                      /// SKU
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "SKU: $sku",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF64748B),
                            fontSize: 11.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 1.2.h),

                      /// STOCK BADGE
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.5.w,
                          vertical: 0.6.h,
                        ),
                        decoration: BoxDecoration(
                          color: stockColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: stockColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          "$stock units",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: stockColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 1.2.h),

                      /// PRICE
                      Text(
                        "₹${price.toStringAsFixed(2)}",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF2563EB),
                          fontWeight: FontWeight.w800,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Cart item card widget displaying product details with quantity controls
class CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quantity = item['quantity'] as int;
    final unitPrice = item['price'] as double;
    final lineTotal = quantity * unitPrice;

    return Dismissible(
      key: Key(item['id'].toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Remove Item', style: theme.textTheme.titleLarge),
              content: Text(
                'Remove ${item['name']} from cart?',
                style: theme.textTheme.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Remove'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: 'delete',
          color: theme.colorScheme.onError,
          size: 24,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: item['image'] as String,
                  width: 20.w,
                  height: 20.w,
                  fit: BoxFit.cover,
                  semanticLabel: item['semanticLabel'] as String,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '₹${unitPrice.toStringAsFixed(2)} each',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colorScheme.outline,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: onDecrement,
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(8),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  child: CustomIconWidget(
                                    iconName: 'remove',
                                    color: theme.colorScheme.primary,
                                    size: 20,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: Text(
                                  quantity.toString(),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: onIncrement,
                                borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(8),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  child: CustomIconWidget(
                                    iconName: 'add',
                                    color: theme.colorScheme.primary,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₹${lineTotal.toStringAsFixed(2)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

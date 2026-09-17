import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Invoice Items Widget - Itemized transaction details
///
/// Displays:
/// - Product names
/// - Quantities
/// - Unit prices
/// - Line totals
/// - Mobile-optimized table layout
class InvoiceItemsWidget extends StatelessWidget {
  final List items;

  const InvoiceItemsWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table header
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(2.w),
                topRight: Radius.circular(2.w),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Item',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.w,
                  child: Text(
                    'Qty',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                  child: Text(
                    'Price',
                    textAlign: TextAlign.right,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(
                  width: 22.w,
                  child: Text(
                    'Total',
                    textAlign: TextAlign.right,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            itemBuilder: (context, index) {
              final item = items[index] as Map<String, dynamic>;
              return Container(
                padding: EdgeInsets.all(3.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        item["name"] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 15.w,
                      child: Text(
                        '${item["quantity"]}',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                      child: Text(
                        '₹${(item["unitPrice"] as double).toStringAsFixed(2)}',
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 22.w,
                      child: Text(
                        '₹${(item["total"] as double).toStringAsFixed(2)}',
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

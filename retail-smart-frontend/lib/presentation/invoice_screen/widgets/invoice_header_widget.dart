import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Invoice Header Widget - Business branding and invoice details
///
/// Displays:
/// - Business logo and name
/// - Invoice number and date
/// - Customer information
/// - Business contact details
class InvoiceHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> invoiceData;

  const InvoiceHeaderWidget({super.key, required this.invoiceData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Business branding section
          Row(
            children: [
              // Business logo
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'store',
                    color: theme.colorScheme.onPrimary,
                    size: 8.w,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoiceData["businessName"] as String,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      invoiceData["businessAddress"] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Business contact details
          Row(
            children: [
              CustomIconWidget(
                iconName: 'phone',
                color: theme.colorScheme.onSurfaceVariant,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                invoiceData["businessPhone"] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: 4.w),
              CustomIconWidget(
                iconName: 'email',
                color: theme.colorScheme.onSurfaceVariant,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  invoiceData["businessEmail"] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Invoice details section
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Invoice Number',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      invoiceData["invoiceNumber"] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      invoiceData["date"] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Customer information section
          Text(
            'Bill To',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            invoiceData["customerName"] as String,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'phone',
                color: theme.colorScheme.onSurfaceVariant,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                invoiceData["customerPhone"] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (invoiceData["customerEmail"] != null) ...[
            SizedBox(height: 0.5.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'email',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    invoiceData["customerEmail"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

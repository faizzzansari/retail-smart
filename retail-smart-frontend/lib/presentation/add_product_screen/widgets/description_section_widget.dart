import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DescriptionSectionWidget extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionSectionWidget({super.key, required this.controller});

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
            'Description',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Product Description',
              hintText: 'Enter product details, features, specifications...',
              alignLabelWithHint: true,
              prefixIcon: Padding(
                padding: EdgeInsets.only(top: 3.w, left: 3.w, right: 3.w),
                child: CustomIconWidget(
                  iconName: 'description',
                  size: 5.w,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            maxLines: 5,
            maxLength: 500,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EssentialDetailsSectionWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController skuController;
  final String? selectedCategory;
  final List<String> categories;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onRegenerateSKU;

  const EssentialDetailsSectionWidget({
    super.key,
    required this.nameController,
    required this.skuController,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
    required this.onRegenerateSKU,
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
            'Essential Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Product Name *',
              hintText: 'Enter product name',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'inventory',
                  size: 5.w,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Product name is required';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),
          DropdownButtonFormField<String>(
            initialValue: selectedCategory,
            decoration: InputDecoration(
              labelText: 'Category *',
              hintText: 'Select category',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'category',
                  size: 5.w,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            items: categories.map((category) {
              return DropdownMenuItem(value: category, child: Text(category));
            }).toList(),
            onChanged: onCategoryChanged,
            validator: (value) {
              if (value == null) {
                return 'Please select a category';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: skuController,
                  decoration: InputDecoration(
                    labelText: 'SKU',
                    hintText: 'Auto-generated',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'tag',
                        size: 5.w,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  readOnly: false,
                ),
              ),
              SizedBox(width: 3.w),
              IconButton(
                onPressed: onRegenerateSKU,
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  size: 6.w,
                  color: theme.colorScheme.primary,
                ),
                tooltip: 'Regenerate SKU',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

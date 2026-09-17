import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ProductImageSectionWidget extends StatelessWidget {
  final XFile? selectedImage;
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  const ProductImageSectionWidget({
    super.key,
    required this.selectedImage,
    required this.onCameraPressed,
    required this.onGalleryPressed,
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
            'Product Image',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Center(
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(selectedImage!.path),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'photo_camera',
                          size: 12.w,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'No image selected',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCameraPressed,
                  icon: CustomIconWidget(
                    iconName: 'camera_alt',
                    size: 5.w,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text('Camera'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onGalleryPressed,
                  icon: CustomIconWidget(
                    iconName: 'photo_library',
                    size: 5.w,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text('Gallery'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

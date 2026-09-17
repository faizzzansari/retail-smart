import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Signature Section Widget - Digital signature capture
///
/// Features:
/// - Touch drawing area for signatures
/// - Clear/Redo functionality
/// - Optional signature for delivery confirmations
/// - Mobile-optimized drawing canvas
class SignatureSectionWidget extends StatefulWidget {
  const SignatureSectionWidget({super.key});

  @override
  State<SignatureSectionWidget> createState() => _SignatureSectionWidgetState();
}

class _SignatureSectionWidgetState extends State<SignatureSectionWidget> {
  bool _hasSignature = false;
  final List<Offset?> _points = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customer Signature (Optional)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (_hasSignature)
                TextButton(
                  onPressed: _clearSignature,
                  child: Text(
                    'Clear',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 1.h),

          // Signature canvas
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                _hasSignature = true;
                _points.add(details.localPosition);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _points.add(details.localPosition);
              });
            },
            onPanEnd: (details) {
              setState(() {
                _points.add(null);
              });
            },
            child: Container(
              width: double.infinity,
              height: 20.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: Stack(
                children: [
                  // Signature hint
                  if (!_hasSignature)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'edit',
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                            size: 8.w,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Sign here',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Signature drawing
                  CustomPaint(
                    painter: _SignaturePainter(
                      points: _points,
                      color: theme.colorScheme.onSurface,
                    ),
                    size: Size.infinite,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'For delivery confirmation and record purposes',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  void _clearSignature() {
    setState(() {
      _hasSignature = false;
      _points.clear();
    });
  }
}

/// Custom painter for signature drawing
class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;

  _SignaturePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

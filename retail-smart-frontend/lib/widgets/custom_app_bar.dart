import 'package:flutter/material.dart';

/// Custom App Bar for retail management application
/// Implements clean, professional design with contextual actions
///
/// Features:
/// - Clean title display with Inter font
/// - Optional leading widget (back button, menu icon)
/// - Optional action buttons (search, settings, etc.)
/// - Consistent elevation and styling
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title text displayed in the app bar
  final String title;

  /// Optional leading widget (typically back button or menu icon)
  final Widget? leading;

  /// Optional list of action widgets (typically IconButtons)
  final List<Widget>? actions;

  /// Whether to show back button automatically
  /// Defaults to true if Navigator can pop
  final bool automaticallyImplyLeading;

  /// Whether to center the title
  /// Defaults to false for left-aligned title
  final bool centerTitle;

  /// Optional bottom widget (typically TabBar)
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.centerTitle = false,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}

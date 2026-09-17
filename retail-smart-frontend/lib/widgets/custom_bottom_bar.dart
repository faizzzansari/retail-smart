import 'package:flutter/material.dart';

/// Custom Bottom Navigation Bar for retail management application
/// Implements thumb-friendly design with three core business functions:
/// - Inventory Management (Product List)
/// - Point of Sale (Billing)
/// - Business Insights (Reports)
///
/// This widget is parameterized and reusable across different implementations.
/// Navigation logic should be handled by the parent widget.
class CustomBottomBar extends StatelessWidget {
  /// Current selected index (0-based)
  final int currentIndex;

  /// Callback function when a navigation item is tapped
  /// Receives the index of the tapped item
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      items: const [
        // Inventory Management - Product List Screen
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          activeIcon: Icon(Icons.inventory_2),
          label: 'Inventory',
          tooltip: 'Manage products and stock',
        ),

        // Point of Sale - Billing Screen
        BottomNavigationBarItem(
          icon: Icon(Icons.point_of_sale_outlined),
          activeIcon: Icon(Icons.point_of_sale),
          label: 'Billing',
          tooltip: 'Process sales and transactions',
        ),

        // Business Insights - Reports Screen
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          activeIcon: Icon(Icons.analytics),
          label: 'Reports',
          tooltip: 'View sales and performance analytics',
        ),
      ],
    );
  }
}

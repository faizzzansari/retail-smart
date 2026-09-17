import 'package:flutter/material.dart';

import '../product_list_screen/product_list_screen.dart';
import '../billing_screen/billing_screen.dart';
import '../report_screen/report_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userRole;
  final String userEmail;

  const HomeScreen({
    super.key,
    required this.userRole,
    required this.userEmail,
  });
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      ProductListScreen(userRole: widget.userRole, userEmail: widget.userEmail),
      const BillingScreen(),
      const ReportScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: 'New Sale',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}

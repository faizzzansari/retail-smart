import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/product_card_widget.dart';
import '../../services/api_service.dart';
import '../add_product_screen/add_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String userRole;
  final String userEmail;

  const ProductListScreen({
    super.key,
    required this.userRole,
    required this.userEmail,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _activeFilters = [];
  // bool _isRefreshing = false;
  // bool _isOfflineMode = false;

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final data = await ApiService.getProducts();

      setState(() {
        _products = List<Map<String, dynamic>>.from(data);
        _filteredProducts = _products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load products";
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    await _loadProducts();
  }

  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = List.from(_products);
      } else {
        _filteredProducts = _products.where((product) {
          final name = (product["name"] as String).toLowerCase();
          final sku = (product["sku"] as String).toLowerCase();
          final searchQuery = query.toLowerCase();
          return name.contains(searchQuery) || sku.contains(searchQuery);
        }).toList();
      }
    });
  }

  void _addFilter(String filter) {
    setState(() {
      if (!_activeFilters.contains(filter)) {
        _activeFilters.add(filter);
        _applyFilters();
      }
    });
  }

  void _removeFilter(String filter) {
    setState(() {
      _activeFilters.remove(filter);
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_products);

    for (String filter in _activeFilters) {
      if (filter == "Low Stock") {
        filtered = filtered
            .where((p) => (p["stock"] ?? 0) < (p["min_stock_alert"] ?? 0))
            .toList();
      } else if (filter == "Beverages" ||
          filter == "Bakery" ||
          filter == "Dairy") {
        filtered = filtered.where((p) => p["category"] == filter).toList();
      } else if (filter == "Under ₹10") {
        filtered = filtered
            .where((p) => (p["selling_price"] as num).toDouble() < 10)
            .toList();
      } else if (filter == "₹10-₹20") {
        filtered = filtered.where((p) {
          final price = p["price"] as double;
          return price >= 10 && price <= 20;
        }).toList();
      }
    }

    setState(() {
      _filteredProducts = filtered;
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "Filter Products",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                "Category",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 1.5.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: ["Beverages", "Bakery", "Dairy", "Grains"].map((
                  category,
                ) {
                  final isSelected = _activeFilters.contains(category);
                  return GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        _removeFilter(category);
                      } else {
                        _addFilter(category);
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.2.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.outline.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        category,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 3.h),
              Text(
                "Price Range",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 1.5.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: ["Under ₹10", "₹10-₹20"].map((range) {
                  final isSelected = _activeFilters.contains(range);
                  return GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        _removeFilter(range);
                      } else {
                        _addFilter(range);
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.2.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.outline.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        range,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 3.h),
              Text(
                "Stock Status",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 1.5.h),
              GestureDetector(
                onTap: () {
                  if (_activeFilters.contains("Low Stock")) {
                    _removeFilter("Low Stock");
                  } else {
                    _addFilter("Low Stock");
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.2.h,
                  ),
                  decoration: BoxDecoration(
                    color: _activeFilters.contains("Low Stock")
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _activeFilters.contains("Low Stock")
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    "Low Stock",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _activeFilters.contains("Low Stock")
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: _activeFilters.contains("Low Stock")
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _navigateToAddProduct({Map<String, dynamic>? product}) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/add-product-screen', arguments: product);
  }

  void _showProductActions(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'edit',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                title: const Text("Edit Details"),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToAddProduct(product: product);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'inventory',
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
                title: const Text("Adjust Stock"),
                onTap: () {
                  Navigator.pop(context);
                  // Handle stock adjustment
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'history',
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 24,
                ),
                title: const Text("View History"),
                onTap: () {
                  Navigator.pop(context);
                  // Handle view history
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'content_copy',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                title: const Text("Duplicate Product"),
                onTap: () {
                  Navigator.pop(context);
                  // Handle duplicate
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleDelete(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Product"),
          content: Text("Are you sure you want to delete ${product["name"]}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _products.removeWhere((p) => p["id"] == product["id"]);
                  _filteredProducts.removeWhere(
                    (p) => p["id"] == product["id"],
                  );
                });
                Navigator.pop(context);
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void _scanBarcode() {
    Navigator.of(context, rootNavigator: true).pushNamed('/add-product-screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Modern Header with Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.85),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Products",
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              "${_filteredProducts.length} items available",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        if (widget.userRole == "admin")
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddProductScreen(
                                      userEmail: widget.userEmail,
                                    ),
                                  ),
                                );
                              },
                              icon: const CustomIconWidget(
                                iconName: 'add',
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    // Enhanced Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _handleSearch,
                        decoration: InputDecoration(
                          hintText: "Search products or SKU...",
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'search',
                              color: theme.colorScheme.primary,
                              size: 22,
                            ),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    _handleSearch('');
                                  },
                                  icon: CustomIconWidget(
                                    iconName: 'close',
                                    color: theme.colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(3.w),
                                  child: GestureDetector(
                                    onTap: _showFilterDialog,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.all(2.w),
                                      child: CustomIconWidget(
                                        iconName: 'filter_list',
                                        color: theme.colorScheme.primary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Active Filters
          if (_activeFilters.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _activeFilters.map((filter) {
                    return Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: FilterChipWidget(
                        label: filter,
                        onRemove: () => _removeFilter(filter),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

          // Product List
          Expanded(
            child: _filteredProducts.isEmpty
                ? const EmptyStateWidget()
                : RefreshIndicator(
                    onRefresh: _handleRefresh,
                    color: theme.colorScheme.primary,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: ProductCardWidget(
                            product: product,
                            onTap: () {
                              // Navigate to product details
                              // Navigator.pushNamed(
                              //   context,
                              //   AppRoutes.billing,
                              //   arguments: product,
                              // );
                            },
                            onLongPress: () {
                              // Show options menu
                              _showProductActions(product);
                            },
                            onDelete: () async {
                              final productId = product["id"];

                              final success = await ApiService.deleteProduct(
                                productId,
                              );

                              if (success) {
                                setState(() {
                                  _products.removeWhere(
                                    (p) => p["id"] == productId,
                                  );
                                  _filteredProducts.removeWhere(
                                    (p) => p["id"] == productId,
                                  );
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Product deleted successfully",
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to delete product"),
                                  ),
                                );
                              }
                            },
                            onEdit: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.addProduct,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

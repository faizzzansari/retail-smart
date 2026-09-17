import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/cart_item_card.dart';
import './widgets/customer_section.dart';
import './widgets/payment_section.dart';
import './widgets/total_summary_card.dart';
import '../../services/api_service.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final List<Map<String, dynamic>> _cartItems = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final TextEditingController _customerEmailController =
      TextEditingController();
  final TextEditingController _amountTenderedController =
      TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  List<dynamic> _frequentCustomers = [];
  bool _isLoadingCustomers = false;

  String _selectedPaymentMethod = 'Cash';
  String _discountType = 'percentage';
  String? _discountReason;
  bool _isScanning = false;

  List<Map<String, dynamic>> _availableProducts = [];
  bool _isLoadingProducts = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _loadFrequentCustomers();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoadingProducts = true);

    final products = await ApiService.getProducts();

    if (products != null) {
      setState(() {
        _availableProducts = products.map((p) {
          return {
            "id": p["id"],
            "name": p["name"],
            "barcode": p["barcode"] ?? "",
            "price": p["selling_price"],
            "stock": p["stock"],
            "image": p["image_url"] ?? "",
            "semanticLabel": p["name"],
          };
        }).toList();
      });
    }

    setState(() => _isLoadingProducts = false);
  }

  Future<void> _loadFrequentCustomers() async {
    setState(() => _isLoadingCustomers = true);

    try {
      final customers = await ApiService.getCustomers();
      // You must create this API method if not created yet

      setState(() {
        _frequentCustomers = customers;
      });
    } catch (e) {
      debugPrint("Failed to load customers: $e");
    } finally {
      setState(() => _isLoadingCustomers = false);
    }
  }

  double get _subtotal {
    return _cartItems.fold(0.0, (sum, item) {
      return sum +
          ((item['price'] as num).toDouble() * (item['quantity'] as int));
    });
  }

  double get _discountAmount {
    if (_discountController.text.isEmpty) return 0.0;

    final discountValue = double.tryParse(_discountController.text) ?? 0.0;

    if (_discountType == 'percentage') {
      return _subtotal * (discountValue / 100);
    }

    return discountValue;
  }

  // 🔥 TAX MUST BE CALCULATED AFTER DISCOUNT
  double get _taxableAmount {
    return _subtotal - _discountAmount;
  }

  double get _taxAmount {
    return _taxableAmount * 0.08;
  }

  double get _grandTotal {
    return _taxableAmount + _taxAmount;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerEmailController.dispose();
    _amountTenderedController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      final existingIndex = _cartItems.indexWhere(
        (item) => item['id'] == product['id'],
      );
      if (existingIndex != -1) {
        _cartItems[existingIndex]['quantity'] =
            (_cartItems[existingIndex]['quantity'] as int) + 1;
      } else {
        _cartItems.add({...product, 'quantity': 1});
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _removeFromCart(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index]['quantity'] =
          (_cartItems[index]['quantity'] as int) + 1;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      final currentQuantity = _cartItems[index]['quantity'] as int;
      if (currentQuantity > 1) {
        _cartItems[index]['quantity'] = currentQuantity - 1;
      } else {
        _removeFromCart(index);
      }
    });
  }

  void _showBarcodeScanner() {
    setState(() => _isScanning = true);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: 70.h,
        child: Column(
          children: [
            AppBar(
              title: const Text('Scan Barcode'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() => _isScanning = false);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Expanded(
              child: MobileScanner(
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    final barcode = barcodes.first.rawValue;
                    if (barcode != null) {
                      _handleBarcodeScanned(barcode);
                      setState(() => _isScanning = false);
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ).whenComplete(() => setState(() => _isScanning = false));
  }

  void _handleBarcodeScanned(String barcode) {
    final product = _availableProducts.firstWhere(
      (p) => p['barcode'] == barcode,
      orElse: () => {},
    );

    if (product.isNotEmpty) {
      _addToCart(product);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product not found'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showProductSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(4.w),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _availableProducts.length,
                  itemBuilder: (context, index) {
                    final product = _availableProducts[index];
                    final searchQuery = _searchController.text.toLowerCase();
                    if (searchQuery.isNotEmpty &&
                        !(product['name'] as String).toLowerCase().contains(
                          searchQuery,
                        )) {
                      return const SizedBox.shrink();
                    }
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: product['image'] as String,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          semanticLabel: product['semanticLabel'] as String,
                        ),
                      ),
                      title: Text(product['name'] as String),
                      subtitle: Text(
                        '₹${(product['price'] as double).toStringAsFixed(2)}',
                      ),
                      trailing: Text(
                        'Stock: ${product['stock']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () {
                        _addToCart(product);
                        Navigator.pop(context);
                        _searchController.clear();
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _generateInvoice() async {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add items to cart'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final saleItems = _cartItems.map((item) {
      return {"product_id": item["id"], "quantity": item["quantity"]};
    }).toList();

    final result = await ApiService.createSale(
      items: saleItems,
      taxPercentage: 8,
      paymentMethod: _selectedPaymentMethod,
      amountTendered: _selectedPaymentMethod == 'Cash'
          ? (double.tryParse(_amountTenderedController.text) ?? 0.0)
          : 0.0,
      customerName: _customerNameController.text,
      phone: _customerPhoneController.text,
      email: _customerEmailController.text,
      discountType: _discountType,
      discountValue: double.tryParse(_discountController.text) ?? 0.0,
      discountReason: _discountReason,
    );

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sale failed"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final invoiceData = {
      'cartItems': _cartItems,
      'customerName': _customerNameController.text,
      'customerPhone': _customerPhoneController.text,
      'customerEmail': _customerEmailController.text,
      'paymentMethod': _selectedPaymentMethod,
      'amountTendered': _selectedPaymentMethod == 'Cash'
          ? (double.tryParse(_amountTenderedController.text) ?? 0.0)
          : 0.0,
      'subtotal': _subtotal,
      'taxAmount': _taxAmount,
      'discountAmount': _discountAmount,
      'grandTotal': _grandTotal,
      'discountReason': _discountReason,
      'timestamp': DateTime.now(),
    };

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/invoice-screen', arguments: invoiceData);

    setState(() {
      _cartItems.clear();
    });

    _fetchProducts(); // refresh stock after sale
  }

  void _clearCart() {
    if (_cartItems.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Remove all items from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _cartItems.clear());
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sale'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _cartItems.length.toString(),
                      style: TextStyle(
                        color: theme.colorScheme.onError,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearCart,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TotalSummaryCard(
              subtotal: _subtotal,
              taxAmount: _taxAmount,
              discountAmount: _discountAmount,
              grandTotal: _grandTotal,
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _showBarcodeScanner,
                      icon: CustomIconWidget(
                        iconName: 'qr_code_scanner',
                        color: theme.colorScheme.onPrimary,
                        size: 20,
                      ),
                      label: const Text('Scan Barcode'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showProductSearch,
                      icon: CustomIconWidget(
                        iconName: 'search',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      label: const Text('Search Product'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            if (_cartItems.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'shopping_cart_outlined',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 64,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Cart is empty',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Scan or search products to add',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  return CartItemCard(
                    item: _cartItems[index],
                    onRemove: () => _removeFromCart(index),
                    onIncrement: () => _incrementQuantity(index),
                    onDecrement: () => _decrementQuantity(index),
                  );
                },
              ),
            SizedBox(height: 2.h),
            CustomerSection(
              nameController: _customerNameController,
              phoneController: _customerPhoneController,
              emailController: _customerEmailController,
              frequentCustomers: _frequentCustomers,
              isLoading: _isLoadingCustomers,
              onQuickAdd: (customer) {
                setState(() {
                  _customerNameController.text = (customer['name'] ?? '')
                      .toString();

                  _customerPhoneController.text = (customer['phone'] ?? '')
                      .toString();

                  _customerEmailController.text = (customer['email'] ?? '')
                      .toString();
                });
              },
            ),
            SizedBox(height: 2.h),
            PaymentSection(
              selectedPaymentMethod: _selectedPaymentMethod,
              onPaymentMethodChanged: (method) {
                setState(() => _selectedPaymentMethod = method);
              },
              amountTenderedController: _amountTenderedController,
              discountType: _discountType,
              onDiscountTypeChanged: (type) {
                setState(() {
                  _discountType = type;
                  _discountController.clear();
                });
              },
              discountController: _discountController,
              discountReason: _discountReason,
              onDiscountReasonChanged: (reason) {
                setState(() => _discountReason = reason);
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateInvoice,
        icon: CustomIconWidget(
          iconName: 'receipt_long',
          color: theme.colorScheme.onPrimary,
          size: 24,
        ),
        label: const Text('Generate Invoice'),
        backgroundColor: _cartItems.isEmpty
            ? theme.colorScheme.onSurfaceVariant
            : null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

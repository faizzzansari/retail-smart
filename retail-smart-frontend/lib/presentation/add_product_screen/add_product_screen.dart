import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';

import '../../widgets/custom_app_bar.dart';
import './widgets/barcode_section_widget.dart';
import './widgets/description_section_widget.dart';
import './widgets/essential_details_section_widget.dart';
import './widgets/pricing_section_widget.dart';
import './widgets/product_image_section_widget.dart';
import './widgets/stock_section_widget.dart';
import '../../services/api_service.dart';

class AddProductScreen extends StatefulWidget {
  final Map<String, dynamic>? productData;
  final String userEmail;

  const AddProductScreen({
    super.key,
    this.productData,
    required this.userEmail,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _minStockController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  String? _selectedCategory;
  XFile? _selectedImage;
  bool _isScanning = false;
  bool _isSaving = false;
  double _marginPercentage = 0.0;

  final List<String> _categories = [
    'Electronics',
    'Groceries',
    'Clothing',
    'Pharmacy',
    'Home & Kitchen',
    'Sports',
    'Books',
    'Toys',
    'Beauty',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _costPriceController.addListener(_calculateMargin);
    _sellingPriceController.addListener(_calculateMargin);
  }

  void _initializeData() {
    if (widget.productData != null) {
      _productNameController.text = widget.productData!['name'] ?? '';
      _barcodeController.text = widget.productData!['barcode'] ?? '';
      _skuController.text = widget.productData!['sku'] ?? '';
      _costPriceController.text =
          widget.productData!['costPrice']?.toString() ?? '';
      _sellingPriceController.text =
          widget.productData!['sellingPrice']?.toString() ?? '';
      _quantityController.text =
          widget.productData!['quantity']?.toString() ?? '';
      _minStockController.text =
          widget.productData!['minStock']?.toString() ?? '';
      _descriptionController.text = widget.productData!['description'] ?? '';
      _selectedCategory = widget.productData!['category'];
      _imageUrlController.text = widget.productData?['image_url'] ?? '';
    } else {
      _generateSKU();
      _quantityController.text = '0';
      _minStockController.text = '5';
    }
  }

  void _generateSKU() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _skuController.text =
        'SKU${timestamp.toString().substring(timestamp.toString().length - 8)}';
  }

  void _calculateMargin() {
    final costPrice = double.tryParse(_costPriceController.text) ?? 0.0;
    final sellingPrice = double.tryParse(_sellingPriceController.text) ?? 0.0;

    if (costPrice > 0 && sellingPrice > 0) {
      setState(() {
        _marginPercentage = ((sellingPrice - costPrice) / costPrice) * 100;
      });
    } else {
      setState(() {
        _marginPercentage = 0.0;
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to scan barcodes'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _startBarcodeScanning() async {
    final hasPermission = await Permission.camera.isGranted;
    if (!hasPermission) {
      await _requestCameraPermission();
      final recheckPermission = await Permission.camera.isGranted;
      if (!recheckPermission) return;
    }

    setState(() {
      _isScanning = true;
    });
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      if (barcode.rawValue != null) {
        setState(() {
          _barcodeController.text = barcode.rawValue!;
          _isScanning = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Barcode scanned: ${barcode.rawValue}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _adjustQuantity(int delta) {
    final currentQuantity = int.tryParse(_quantityController.text) ?? 0;
    final newQuantity = (currentQuantity + delta).clamp(0, 999999);
    _quantityController.text = newQuantity.toString();
  }

  bool _validateForm() {
    if (_productNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product name is required'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    final costPrice = double.tryParse(_costPriceController.text);
    final sellingPrice = double.tryParse(_sellingPriceController.text);

    if (costPrice == null || costPrice < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid cost price'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    if (sellingPrice == null || sellingPrice < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid selling price'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _saveProduct() async {
    if (!_validateForm()) return;

    setState(() {
      _isSaving = true;
    });

    String? imageUrl;

    // Option 1: Manual URL
    if (_imageUrlController.text.trim().isNotEmpty) {
      imageUrl = _imageUrlController.text.trim();
    }
    // Option 2: Upload Selected Image
    else if (_selectedImage != null) {
      imageUrl = await ApiService.uploadImage(File(_selectedImage!.path));
    }

    try {
      final productData = {
        "name": _productNameController.text.trim(),
        "sku": _skuController.text.trim(),
        "barcode": _barcodeController.text.trim(),
        "category": _selectedCategory,
        "cost_price": double.tryParse(_costPriceController.text) ?? 0.0,
        "selling_price": double.tryParse(_sellingPriceController.text) ?? 0.0,
        "stock": int.tryParse(_quantityController.text) ?? 0,
        "minimum_stock_alert": int.tryParse(_minStockController.text) ?? 5,
        "description": _descriptionController.text.trim(),
        "image_url": imageUrl, // for now
      };

      final success = await ApiService.addProduct(
        productData,
        widget.userEmail,
      );

      setState(() {
        _isSaving = false;
      });

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Product Added Successfully"),
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.pop(context, {
          "name": _productNameController.text.trim(),
          "sku": _skuController.text.trim(),
          "barcode": _barcodeController.text.trim(),
          "category": _selectedCategory,
          "cost_price": double.tryParse(_costPriceController.text) ?? 0.0,
          "selling_price": double.tryParse(_sellingPriceController.text) ?? 0.0,
          "stock": int.tryParse(_quantityController.text) ?? 0,
          "minimum_stock_alert": int.tryParse(_minStockController.text) ?? 5,
          "description": _descriptionController.text.trim(),
          "image_url": imageUrl,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to add product"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _barcodeController.dispose();
    _skuController.dispose();
    _costPriceController.dispose();
    _sellingPriceController.dispose();
    _quantityController.dispose();
    _minStockController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isScanning) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Scan Barcode'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _isScanning = false;
              });
            },
          ),
        ),
        body: Stack(
          children: [
            MobileScanner(onDetect: _onBarcodeDetected),
            Positioned(
              bottom: 4.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Position barcode within frame',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.productData != null ? 'Edit Product' : 'Add Product',
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Text(
              'Cancel',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProductImageSectionWidget(
                  selectedImage: _selectedImage,
                  onCameraPressed: _pickImageFromCamera,
                  onGalleryPressed: _pickImageFromGallery,
                ),
                SizedBox(height: 2.h),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    labelText: "Or Enter Image URL",
                    hintText: "https://example.com/image.jpg",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                BarcodeSectionWidget(
                  controller: _barcodeController,
                  onScanPressed: _startBarcodeScanning,
                ),
                SizedBox(height: 3.h),
                EssentialDetailsSectionWidget(
                  nameController: _productNameController,
                  skuController: _skuController,
                  selectedCategory: _selectedCategory,
                  categories: _categories,
                  onCategoryChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  onRegenerateSKU: _generateSKU,
                ),
                SizedBox(height: 3.h),
                PricingSectionWidget(
                  costPriceController: _costPriceController,
                  sellingPriceController: _sellingPriceController,
                  marginPercentage: _marginPercentage,
                ),
                SizedBox(height: 3.h),
                StockSectionWidget(
                  quantityController: _quantityController,
                  minStockController: _minStockController,
                  onAdjustQuantity: _adjustQuantity,
                ),
                SizedBox(height: 3.h),
                DescriptionSectionWidget(controller: _descriptionController),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isSaving ? null : _saveProduct,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 6.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isSaving
                ? SizedBox(
                    height: 2.5.h,
                    width: 2.5.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Text(
                    widget.productData != null
                        ? 'Update Product'
                        : 'Save Product',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

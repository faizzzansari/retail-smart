import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ApiService {
  static const String baseUrl = "https://retail-smart-backend.onrender.com";
  // static const String baseUrl = "http://127.0.0.1:8000/";

  // ================= PRODUCT APIs =================

  static Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  // ADD PRODUCT
  static Future<bool> addProduct(
    Map<String, dynamic> productData,
    String email,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add-product?email=$email"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(productData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteProduct(String productId) async {
    final url = Uri.parse('$baseUrl/delete-product/$productId');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String?> uploadImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload-image'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = jsonDecode(await response.stream.bytesToString());
      return baseUrl + responseData["image_url"];
    } else {
      return null;
    }
  }

  static Future<bool> updateProduct(
    String productId,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse('$baseUrl/update-product/$productId');

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // ================= SALES APIs =================

  static Future<Map<String, dynamic>?> createSale({
    required List<Map<String, dynamic>> items,
    required double taxPercentage,
    required String paymentMethod,
    required double amountTendered,
    String? customerName,
    String? phone,
    String? email,
    String? discountType,
    double? discountValue,
    String? discountReason,
  }) async {
    final body = {
      "items": items,
      "customer_name": customerName,
      "phone": phone,
      "email": email,
      "payment_method": paymentMethod,
      "amount_tendered": amountTendered,
      "discount_type": discountType,
      "discount_value": discountValue ?? 0,
      "discount_reason": discountReason,
      "tax_percentage": taxPercentage,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/create-sale'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<List<dynamic>> getCustomers() async {
    final response = await http.get(Uri.parse('$baseUrl/customers/frequent'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load customers');
    }
  }

  // ================= REPORTS API =================

  static Future<Map<String, dynamic>> getReports({
    String? period,
    String? startDate,
    String? endDate,
  }) async {
    String url = "$baseUrl/reports";

    if (period != null) {
      url += "?period=$period";
    } else if (startDate != null && endDate != null) {
      url += "?start_date=$startDate&end_date=$endDate";
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load reports");
    }
  }
}

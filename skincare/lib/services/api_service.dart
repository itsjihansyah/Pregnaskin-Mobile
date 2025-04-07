import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skincare/models/product.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  // Fetch all products with pagination and sorting
  Future<List<Product>> fetchProducts({
    int page = 1,
    int pageSize = 10,
    String sortBy = 'latest',
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/products?page=$page&per_page=$pageSize&sort_by=$sortBy'),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded['products'];
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Something went wrong while fetching products');
    }
  }

  // Fetch similar products based on product ID
  Future<List<Product>> fetchAlternativeProducts(
    int productId, {
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/similar-products/$productId?page=$page&per_page=$pageSize'),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['products'] is List) {
          return (decoded['products'] as List)
              .map((item) => Product.fromJson(item))
              .toList();
        } else {
          throw Exception('Unexpected response format for similar products');
        }
      } else {
        throw Exception('Failed to load alternative products');
      }
    } catch (e) {
      print('Error fetching similar products: $e');
      throw Exception('Something went wrong while fetching similar products');
    }
  }

  // Search products by keyword
  Future<List<Product>> searchProducts(
    String query, {
    String sortBy = 'rating',
    String order = 'desc',
  }) async {
    try {
      final uri = Uri.parse(
        "$baseUrl/products/search?q=$query&sort_by=$sortBy&order=$order",
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded['products'];
        return data.map<Product>((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load search products");
      }
    } catch (e) {
      print('Error searching products: $e');
      throw Exception('Something went wrong while searching products');
    }
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skincare/models/alternative_product.dart';
import 'package:skincare/models/filter_selection.dart';
import 'package:skincare/models/product.dart';

class PaginatedResult<T> {
  final List<T> products;
  final int total;

  PaginatedResult({required this.products, required this.total});
}

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

  // Method to get filtered products
  static Future<List<Product>> getFilteredProducts(
      FilterSelection filters) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products/filter'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(filters.toJson()),
      );

      if (response.statusCode == 200) {
        // Parse the response and return the filtered products
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((productJson) => Product.fromJson(productJson))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedResult<Product>> fetchProductsWithPagination({
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
        final int total = decoded['total'];
        final products = data.map((item) => Product.fromJson(item)).toList();

        return PaginatedResult<Product>(products: products, total: total);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Something went wrong while fetching products');
    }
  }

  // Add pagination to search products
  Future<PaginatedResult<Product>> searchProductsWithPagination(
    String query, {
    int page = 1,
    int pageSize = 10,
    String sortBy = 'rating',
    String order = 'desc',
  }) async {
    try {
      final uri = Uri.parse(
        "$baseUrl/products/search?q=$query&sort_by=$sortBy&order=$order&page=$page&per_page=$pageSize",
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded['products'];
        final int total = decoded['total'];
        final products =
            data.map<Product>((item) => Product.fromJson(item)).toList();

        return PaginatedResult<Product>(products: products, total: total);
      } else {
        throw Exception("Failed to load search products");
      }
    } catch (e) {
      print('Error searching products: $e');
      throw Exception('Something went wrong while searching products');
    }
  }

  // Add pagination to filtered products
  Future<PaginatedResult<Product>> getFilteredProductsWithPagination(
      Map<String, dynamic> filters,
      {required int page,
      required int pageSize}) async {
    try {
      // Add pagination parameters to the filters map
      filters['page'] = page;
      filters['per_page'] = pageSize;

      final response = await http.post(
        Uri.parse('$baseUrl/products/filter'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filters),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded['products'];
        final int total = decoded['total'];
        final products =
            data.map((product) => Product.fromJson(product)).toList();

        print("API Filter response: ${response.body}");

        return PaginatedResult<Product>(products: products, total: total);
      } else {
        throw Exception('Failed to load filtered products');
      }
    } catch (e) {
      print("Error fetching filtered products: $e");
      throw Exception('Something went wrong while fetching filtered products');
    }
  }

  // Method for fetching alternative products (with or without filters)
  Future<PaginatedResult<Product>> getFilteredAlternativeWithPagination(
    int productId,
    Map<String, dynamic> queryParams, {
    required int page,
    required int pageSize,
  }) async {
    try {
      // Create parameters map - make a safe copy to avoid modifying original
      Map<String, dynamic> params = Map.from(queryParams);

      // Add pagination parameters
      params['page'] = page;
      params['per_page'] = pageSize;

      // Always sort by highest match by default, unless specified otherwise
      if (!params.containsKey('sort_by')) {
        params['sort_by'] = 'match_percentage';
      }

      // Always use descending order for match percentage (highest first)
      if (!params.containsKey('order')) {
        params['order'] = 'desc';
      }

      // Log what we're sending to the API
      debugPrint("Sending to API: ${json.encode(params)}");

      // Determine if we should use the filtering endpoint - check if any filter params exist
      bool useFilterEndpoint = params.containsKey('minRating') ||
          params.containsKey('maxRating') ||
          params.containsKey('skin_types') ||
          params.containsKey('conditions') ||
          params.containsKey('countries');

      http.Response response;

      if (useFilterEndpoint) {
        // Use POST with filter-similar endpoint
        Uri filterUri =
            Uri.parse('$baseUrl/products/filter-similar/$productId');

        // Normalize array parameters for JSON
        _normalizeArrayParameters(params);

        debugPrint("Using filter endpoint: $filterUri");
        debugPrint("With params: ${json.encode(params)}");

        response = await http.post(
          filterUri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(params),
        );
      } else {
        // Use GET with similar-products endpoint for non-filtered requests
        // Convert all values to strings for query parameters
        Map<String, String> stringParams = {};

        params.forEach((key, value) {
          if (value != null) {
            if (value is List) {
              // Handle list parameters for GET requests
              stringParams[key] = json.encode(value);
            } else {
              stringParams[key] = value.toString();
            }
          }
        });

        Uri uri = Uri.parse('$baseUrl/products/similar-products/$productId')
            .replace(queryParameters: stringParams);

        debugPrint("Using standard endpoint: $uri");
        response = await http.get(uri);
      }

      if (response.statusCode == 200) {
        debugPrint("API Response: ${response.body}");
        final decoded = json.decode(response.body);

        // Handle potential errors in response format
        if (!decoded.containsKey('products')) {
          throw Exception(
              "API response missing 'products' field: ${response.body}");
        }

        final List<dynamic> data = decoded['products'];
        final int total = decoded['total'] ?? data.length;

        // Create product objects from the response
        final List<AlternativeProduct> products = [];

        for (var item in data) {
          try {
            products.add(AlternativeProduct.fromJson(item));
          } catch (e) {
            debugPrint("Error parsing product: $e for item: $item");
            // Skip invalid products instead of failing
          }
        }

        // If we're sorting by match percentage, make sure the products are sorted
        if (params['sort_by'] == 'match_percentage') {
          products
              .sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));
        }

        return PaginatedResult<Product>(products: products, total: total);
      } else {
        debugPrint("API Error: ${response.statusCode}, Body: ${response.body}");
        throw Exception(
            'Failed to load alternatives: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Error fetching alternative products: $e");
      throw Exception('Error fetching alternatives: $e');
    }
  }

  // Helper method to normalize array parameters
  void _normalizeArrayParameters(Map<String, dynamic> params) {
    // Handle skin_types parameter
    if (params.containsKey('skin_types')) {
      var skinTypes = params['skin_types'];
      if (skinTypes is String) {
        try {
          params['skin_types'] = json.decode(skinTypes);
        } catch (_) {
          params['skin_types'] = [skinTypes];
        }
      } else if (skinTypes is! List) {
        // If it's not already a list, make it one
        params['skin_types'] = [skinTypes.toString()];
      }
    }

    // Handle conditions parameter
    if (params.containsKey('conditions')) {
      var conditions = params['conditions'];
      if (conditions is String) {
        try {
          params['conditions'] = json.decode(conditions);
        } catch (_) {
          params['conditions'] = [conditions];
        }
      } else if (conditions is! List) {
        params['conditions'] = [conditions.toString()];
      }
    }

    // Handle countries parameter
    if (params.containsKey('countries')) {
      var countries = params['countries'];
      if (countries is String) {
        try {
          params['countries'] = json.decode(countries);
        } catch (_) {
          params['countries'] = [countries];
        }
      } else if (countries is! List) {
        params['countries'] = [countries.toString()];
      }
    }
  }
}

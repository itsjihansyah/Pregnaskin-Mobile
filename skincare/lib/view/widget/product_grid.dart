import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skincare/view/widget/product_card.dart';
import 'package:skincare/models/product.dart';
import '../items_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skincare/view/widget/product_card.dart';
import 'package:skincare/models/product.dart';
import '../items_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductGrid extends StatefulWidget {
  final String selectedCategory;
  final String searchQuery;

  const ProductGrid({
    Key? key,
    required this.selectedCategory,
    required this.searchQuery,
  }) : super(key: key);

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  List<Product> products = [];
  bool isLoading = false;
  bool isInitialLoad = true;
  bool hasMore = true;
  int page = 1;
  final int pageSize = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50 &&
        !isLoading &&
        hasMore) {
      fetchProducts();
    }
  }

  Future<void> fetchProducts() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Add pagination param to search endpoint
      final Uri uri = widget.searchQuery.isNotEmpty
          ? Uri.parse(
              'http://10.0.2.2:8000/products/search?q=${Uri.encodeComponent(widget.searchQuery)}&sort_by=rating&order=desc&page=$page&per_page=$pageSize')
          : Uri.parse(
              'http://10.0.2.2:8000/products/?page=$page&per_page=$pageSize');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded['products'];
        final int totalItems = decoded['total'];
        final List<Product> fetchedProducts =
            data.map((json) => Product.fromJson(json)).toList();

        setState(() {
          // Append fetched products to the list
          if (page == 1) {
            products = fetchedProducts;
          } else {
            final newProducts = fetchedProducts.where((newProduct) {
              return !products.any(
                  (existingProduct) => existingProduct.id == newProduct.id);
            }).toList();
            products.addAll(newProducts);
          }

          // Update pagination state based on total count
          hasMore = products.length < totalItems;
          if (hasMore) {
            page++;
          }
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() {
        isLoading = false;
        isInitialLoad = false;
      });
    }
  }

  @override
  void didUpdateWidget(ProductGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory ||
        oldWidget.searchQuery != widget.searchQuery) {
      setState(() {
        products.clear();
        page = 1;
        hasMore = true;
        isInitialLoad = true;
      });
      fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isInitialLoad && products.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    // Use products directly if searchQuery was used to hit /search
    final displayProducts = widget.searchQuery.isNotEmpty
        ? products
        : products.where((product) {
            final query = widget.searchQuery.toLowerCase();
            return product.name.toLowerCase().contains(query) ||
                product.brand.toLowerCase().contains(query) ||
                (product.type?.toLowerCase() ?? '').contains(query) ||
                product.category.toLowerCase().contains(query);
          }).toList();

    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemCount: displayProducts.length,
      itemBuilder: (context, index) {
        final product = displayProducts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemsDetail(
                  productId: product.id,
                  product: product,
                ),
              ),
            );
          },
          child: ProductCard(product: product),
        );
      },
    );
  }
}

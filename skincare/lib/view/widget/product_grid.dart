import 'package:flutter/material.dart';
import 'package:skincare/view/widget/product_card.dart';
import 'package:skincare/models/product.dart';
import '../items_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skincare/models/filter_selection.dart';
import 'package:skincare/services/api_service.dart';

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  final bool showLoading;

  const ProductGrid({
    Key? key,
    required this.products,
    this.showLoading = false,
  }) : super(key: key);

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Check if we're near the bottom of the scroll view
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      // Notify parent to load more products if needed
      // This could be implemented with a callback passed to the widget
      // For now, we'll rely on the parent handling pagination
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showLoading && widget.products.isEmpty) {
      return Center(
          child: CircularProgressIndicator(
        strokeWidth: 4,
        color: Colors.black,
      ));
    }

    if (!widget.showLoading && widget.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView(
      controller: _scrollController,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.7,
          ),
          itemCount: widget.products.length,
          itemBuilder: (context, index) {
            final product = widget.products[index];
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
        ),
        // Loading indicator that scrolls with content
        if (widget.showLoading)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: Colors.black,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

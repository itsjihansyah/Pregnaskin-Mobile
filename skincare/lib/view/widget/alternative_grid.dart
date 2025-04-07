import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/alternative_product.dart';
import 'alternative_card.dart';
import '../alternative_detail.dart';

class AlternativeGrid extends StatefulWidget {
  final int productId;

  const AlternativeGrid({super.key, required this.productId});

  @override
  State<AlternativeGrid> createState() => _AlternativeGridState();
}

class _AlternativeGridState extends State<AlternativeGrid> {
  final List<AlternativeProduct> _alternativeProducts = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchAlternativeProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _fetchAlternativeProducts();
    }
  }

  Future<void> _fetchAlternativeProducts() async {
    setState(() => _isLoading = true);

    try {
      final url = Uri.parse(
        'http://10.0.2.2:8000/products/similar-products/${widget.productId}?page=$_page&per_page=$_pageSize',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded['products'];
        final int total = decoded['total'] ?? (_page * _pageSize);

        final List<AlternativeProduct> fetched =
            data.map((json) => AlternativeProduct.fromJson(json)).toList();

        setState(() {
          _alternativeProducts.addAll(fetched);
          _hasMore = _alternativeProducts.length < total;
          _page++;
        });
      } else {
        debugPrint("Failed to load alternatives: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching alternatives: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_alternativeProducts.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _hasMore
          ? _alternativeProducts.length + 1
          : _alternativeProducts.length,
      itemBuilder: (context, index) {
        if (index == _alternativeProducts.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = _alternativeProducts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlternativeDetail(
                  alternativeProduct: product,
                ),
              ),
            );
          },
          child: AlternativeCard(alternativeProduct: product),
        );
      },
    );
  }
}

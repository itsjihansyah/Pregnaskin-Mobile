import 'package:flutter/material.dart';
import 'package:skincare/models/product.dart';
import 'package:skincare/models/filter_selection_alternative.dart';
import 'package:skincare/services/api_service.dart';

import '../../models/alternative_product.dart';
import 'alternative_card.dart';
import '../alternative_detail.dart';

class AlternativeGrid extends StatefulWidget {
  final int productId;
  final Product originalProduct;
  final FilterSelectionAlternative? filters;
  final String? category;

  const AlternativeGrid({
    Key? key,
    required this.productId,
    required this.originalProduct,
    this.filters,
    this.category,
  }) : super(key: key);

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
  final ApiService _apiService = ApiService();

  // Track previous filter parameters to detect changes
  FilterSelectionAlternative? _previousFilters;
  String? _previousCategory;

  @override
  void initState() {
    super.initState();
    _fetchAlternativeProducts();
    _scrollController.addListener(_onScroll);

    // Store initial filters and category
    _previousFilters = widget.filters;
    _previousCategory = widget.category;
  }

  @override
  void didUpdateWidget(AlternativeGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if filters or category changed
    bool filtersChanged = widget.filters != _previousFilters;
    bool categoryChanged = widget.category != _previousCategory;

    if (filtersChanged || categoryChanged) {
      // Reset and reload data
      _resetAndReload();

      // Update tracked values
      _previousFilters = widget.filters;
      _previousCategory = widget.category;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _resetAndReload() {
    setState(() {
      _alternativeProducts.clear();
      _page = 1;
      _hasMore = true;
      _isLoading = false;
    });
    _fetchAlternativeProducts();
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
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // Create query parameters map
      Map<String, dynamic> queryParams = {};

      // Add category-based sorting if available
      if (widget.category != null) {
        String sortBy = _getSortByFromCategory(widget.category!);
        queryParams['sort_by'] = sortBy;
      }

      // Combine filters with query params if filters exist
      final Map<String, dynamic> finalParams =
          widget.filters != null ? widget.filters!.toJson() : queryParams;

      // Debug the parameters being sent
      debugPrint("Request params: $finalParams");

      // Use ApiService to fetch filtered alternatives
      final result = await _apiService.getFilteredAlternativeWithPagination(
        widget.productId,
        finalParams,
        page: _page,
        pageSize: _pageSize,
      );

      if (mounted) {
        setState(() {
          // Cast the products to AlternativeProduct and add to the list
          for (var product in result.products) {
            if (product is AlternativeProduct) {
              _alternativeProducts.add(product);
            }
          }

          _hasMore = _alternativeProducts.length < result.total;
          _page++;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching alternatives: $e");
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  String _getSortByFromCategory(String category) {
    switch (category) {
      case 'Match Features':
        return 'match_percentage';
      case 'Match Ingredients':
        return 'match_ingredients';
      default:
        return 'match_percentage';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_alternativeProducts.isEmpty && _isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        strokeWidth: 4,
        color: Colors.black,
      ));
    }

    if (_alternativeProducts.isEmpty && !_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No alternatives found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Try adjusting your filters",
              style: TextStyle(color: Colors.grey),
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
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _alternativeProducts.length,
          itemBuilder: (context, index) {
            final product = _alternativeProducts[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlternativeDetail(
                      originalProduct: widget.originalProduct,
                      alternativeProduct: product,
                    ),
                  ),
                );
              },
              child: AlternativeCard(alternativeProduct: product),
            );
          },
        ),
        // Loading indicator that scrolls with content
        if (_isLoading)
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

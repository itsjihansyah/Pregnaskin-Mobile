import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skincare/models/filter_selection.dart';
import 'package:skincare/models/product.dart';
import 'package:skincare/services/api_service.dart';
import 'package:skincare/utils/app_textstyles.dart';
import 'package:skincare/view/filter_home.dart';
import 'package:skincare/view/widget/category_chips.dart';
import 'package:skincare/view/widget/custom_search_bar.dart';
import 'package:skincare/view/widget/product_card.dart';
import 'package:skincare/view/widget/product_grid.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  String selectedCategory = 'Popular';
  String searchQuery = '';
  FilterSelection? appliedFilters;
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _pageSize = 10;

  // Helper method to count total applied filters
  int get totalFiltersApplied {
    if (appliedFilters == null) return 0;

    int count = 0;
    if (appliedFilters!.categories.isNotEmpty)
      count += appliedFilters!.categories.length;
    if (appliedFilters!.skinTypes.isNotEmpty)
      count += appliedFilters!.skinTypes.length;
    if (appliedFilters!.conditions.isNotEmpty)
      count += appliedFilters!.conditions.length;
    if (appliedFilters!.safetyOptions.isNotEmpty)
      count += appliedFilters!.safetyOptions.length;
    if (appliedFilters!.countries.isNotEmpty)
      count += appliedFilters!.countries.length;

    // Add 1 for rating if it's not the default range (0-5)
    if (appliedFilters!.ratingRange.start > 0 ||
        appliedFilters!.ratingRange.end < 5) {
      count += 1;
    }

    return count;
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts({bool loadMore = false}) async {
    if (!loadMore) {
      setState(() {
        _isLoading = true;
        _currentPage = 1;
        _hasMore = true;
        if (!loadMore) {
          _products = [];
        }
      });
    } else {
      if (!_hasMore || _isLoadingMore) {
        return;
      }
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      List<Product> newProducts = [];
      int totalItems = 0;

      if (searchQuery.isNotEmpty && appliedFilters != null) {
        // Apply both search and filters
        Map<String, dynamic> filters = {
          ...appliedFilters!.toJson(),
          'search': searchQuery,
          'page': _currentPage,
          'per_page': _pageSize,
          'sort_by': _getSortByFromCategory(selectedCategory),
          'order': 'desc',
        };

        final result = await _apiService.getFilteredProductsWithPagination(
          filters,
          page: _currentPage,
          pageSize: _pageSize,
        );
        newProducts = result.products;
        totalItems = result.total;
      } else if (searchQuery.isNotEmpty) {
        // Only search
        final result = await _apiService.searchProductsWithPagination(
          searchQuery,
          page: _currentPage,
          pageSize: _pageSize,
        );
        newProducts = result.products;
        totalItems = result.total;
      } else if (appliedFilters != null) {
        // Only filters
        Map<String, dynamic> filters = appliedFilters!.toJson();
        filters['page'] = _currentPage;
        filters['per_page'] = _pageSize;

        final result = await _apiService.getFilteredProductsWithPagination(
          filters,
          page: _currentPage,
          pageSize: _pageSize,
        );
        newProducts = result.products;
        totalItems = result.total;
      } else {
        // No search or filters, get default products
        final result = await _apiService.fetchProductsWithPagination(
          page: _currentPage,
          pageSize: _pageSize,
          sortBy: _getSortByFromCategory(selectedCategory),
        );
        newProducts = result.products;
        totalItems = result.total;
      }

      setState(() {
        if (loadMore) {
          // Filter out duplicates when loading more
          final uniqueNewProducts = newProducts.where((newProduct) {
            return !_products
                .any((existingProduct) => existingProduct.id == newProduct.id);
          }).toList();
          _products.addAll(uniqueNewProducts);
        } else {
          _products = newProducts;
        }

        _hasMore = _products.length < totalItems;
        if (_hasMore) {
          _currentPage++;
        }
      });
    } catch (e) {
      print('Error loading products: $e');
      // Show error to user
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  String _getSortByFromCategory(String category) {
    switch (category) {
      case 'Popular':
        return 'popularity';
      case 'Latest':
        return 'latest';
      case 'For You':
        return 'recommended';
      default:
        return 'latest';
    }
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      appliedFilters = null;
    });
    _loadProducts();
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
    _loadProducts();
  }

  void _openFilterScreen() async {
    final result = await showModalBottomSheet<FilterSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: FilterHome(initialFilters: appliedFilters),
      ),
    );

    if (result != null) {
      setState(() {
        appliedFilters = result;
      });
      _loadProducts();
    }
  }

  void _loadMoreProducts() {
    if (_hasMore && !_isLoading && !_isLoadingMore) {
      _loadProducts(loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterCount = totalFiltersApplied;

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning ⛅',
                        style: TextStyle(
                          color: Color(0xFF979AAC),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Jihan Syahira',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.favorite_outline)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_outlined))
                ],
              ),
            ),
            // Search bar with filter badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: CustomSearchBar(
                        onSearch: onSearch,
                      ),
                    ),
                  ),

                  // filter icon and badge
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: _openFilterScreen,
                      ),
                      if (filterCount > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Center(
                              child: Text(
                                '$filterCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            CategoryChips(
              categories: ['Popular', 'For You', 'Latest'],
              selectedCategory: selectedCategory,
              onCategorySelected: onCategorySelected,
            ),
            const SizedBox(height: 8),

            _isLoading && _products.isEmpty
                ? Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: Colors.black,
                  )))
                : Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo is ScrollEndNotification) {
                          if (scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent - 200) {
                            _loadMoreProducts();
                          }
                        }
                        return false;
                      },
                      child: ProductGrid(
                        products: _products,
                        showLoading: _isLoadingMore && _hasMore,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

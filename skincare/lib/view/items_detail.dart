import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:skincare/view/alternative_filter.dart';
import '../../models/product.dart';
import '../../models/filter_selection_alternative.dart';
import '../utils/app_textstyles.dart';
import 'alternative_page.dart';
import 'alternative_filter.dart';
import 'package:skincare/view/widget/feature_chips.dart';

class ItemsDetail extends StatefulWidget {
  final int productId;
  final Product product;

  ItemsDetail({Key? key, required this.productId, required this.product})
      : super(key: key);

  @override
  State<ItemsDetail> createState() => _ItemsDetailState();
}

class _ItemsDetailState extends State<ItemsDetail>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Future<Product?>? _productFuture;
  FilterSelectionAlternative? _selectedFilters;

  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  Future<Product?> fetchProductDetails() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/products/${widget.productId}'));

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      throw Exception('Error fetching data: ${e.toString()}');
    }
  }

  // Open filter modal and get selected filters
  // Enhanced filter modal with better user feedback
  Future<void> _openFilterModal() async {
    final result = await showModalBottomSheet<FilterSelectionAlternative>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: FilterAlternative(
          initialFilters: _selectedFilters,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedFilters = result;
      });

      // // Show a snackbar confirming filters were applied (optional)
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       'Filters applied',
      //       style: AppTextStyle.withColor(AppTextStyle.bodySmall, Colors.white),
      //     ),
      //     duration: Duration(seconds: 2),
      //     behavior: SnackBarBehavior.floating,
      //   ),
      // );
    }
  }

  // Navigate to alternatives page with filter
  void _navigateToAlternatives() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlternativePage(
          product: widget.product,
          initialFilters: _selectedFilters,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildProductDetail(widget.product)),
          _buildBottomNavigation(widget.product),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.chevron_left_rounded, size: 32),
      ),
      title: Text("Detail",
          style: AppTextStyle.withWeight(AppTextStyle.h3, FontWeight.w600)),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Iconify(MaterialSymbols.favorite_outline_rounded, size: 28),
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
        child: CircularProgressIndicator(
      strokeWidth: 4,
      color: Colors.black,
    ));
  }

  Widget _buildErrorScreen(String errorMessage) {
    return Center(
      child: Text(errorMessage, style: TextStyle(color: Colors.red)),
    );
  }

  Widget _buildProductDetail(Product product) {
    return ListView(
      children: [
        _buildProductImage(product.image_url),
        _buildProductInfo(product),
        _buildTabs(),
        _buildTabContent(product),
      ],
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    return Container(
      margin: EdgeInsets.only(top: 24),
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.34,
      width: double.infinity,
      child: Image.network(
        imageUrl ??
            'https://skinsort.com/rails/active_storage/representations/proxy/placeholder.jpg',
        fit: BoxFit.fitHeight,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildProductInfo(Product product) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // safety chip
          Chip(
            label: Text(
              product.safe ?? "Unknown",
              style:
                  AppTextStyle.withColor(AppTextStyle.bodyMedium, Colors.white),
            ),
            backgroundColor: product.safe?.toLowerCase() == 'safe'
                ? Colors.black
                : Color(0xFF979AAC),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(height: 4),

          // name and rating
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style:
                      AppTextStyle.withWeight(AppTextStyle.h2, FontWeight.w600),
                ),
              ),
              SizedBox(width: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Color(0xFFF3BB2D), size: 26),
                  SizedBox(width: 4),
                  Text(
                    product.rating?.toStringAsFixed(1) ?? '0.0',
                    style: AppTextStyle.withWeight(
                        AppTextStyle.bodyLarge, FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4),

          // brand
          Text(
            product.brand,
            style: AppTextStyle.withColor(
                AppTextStyle.bodyLarge, Color(0xFF979AAC)),
          ),
          SizedBox(height: 8),

          // show the warning for unsafe products
          if (product.safe?.toLowerCase() == 'unsafe')
            _buildUnsafeWarning(product),
        ],
      ),
    );
  }

  Widget _buildUnsafeWarning(Product product) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Iconify(MaterialSymbols.warning_outline_rounded,
              color: Colors.black, size: 43),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Unsafe:',
                    style: AppTextStyle.withColor(
                        AppTextStyle.bodySmall, Colors.black)),
                Text(
                  'Containing ${product.unsafe_reason ?? "Unknown"}',
                  style: AppTextStyle.withWeight(
                      AppTextStyle.bodyLarge, FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tab bar
  Widget _buildTabs() {
    return Container(
      width: double.infinity,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Color(0xFFFAFAFA)),
        labelStyle:
            AppTextStyle.withWeight(AppTextStyle.bodyMedium, FontWeight.bold),
        unselectedLabelStyle:
            AppTextStyle.withWeight(AppTextStyle.bodyMedium, FontWeight.w400),
        splashFactory: InkRipple.splashFactory,
        labelColor: Colors.black,
        indicatorColor: Colors.black,
        tabs: [
          Tab(text: "Overview"),
          Tab(text: "Features"),
          Tab(text: "Ingredients"),
        ],
      ),
    );
  }

  // Tab content
  Widget _buildTabContent(Product product) {
    final List<Widget> tabContents = [
      // Overview
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product overview in desc
          if (product.good_for != null && product.good_for!.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.only(right: 24),
              child: Text(product.good_for!),
            ),
            SizedBox(height: 24),
          ],

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(right: 24),
            child: Row(
              children: [
                _buildFeatureContainer(
                    Mdi.earth, product.country ?? "Unknown", "Product"),
                SizedBox(width: 12),
                if (product.dry_skin == true) ...[
                  _buildFeatureContainer(
                      MaterialSymbols.cool_to_dry_outline, "Dry", "Skin"),
                  SizedBox(width: 12),
                ],
                if (product.oily_skin == true) ...[
                  _buildFeatureContainer(Ph.drop_half_bottom, "Oily", "Skin"),
                  SizedBox(width: 12),
                ],
                if (product.sensitive_skin == true) ...[
                  _buildFeatureContainer(Ph.egg_crack, "Sensitive", "Skin"),
                  SizedBox(width: 12),
                ],
              ],
            ),
          ),
        ],
      ),

      // Features
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.benefits != null && product.benefits!.isNotEmpty) ...[
            Text(
              "Benefits",
              style: AppTextStyle.withWeight(
                  AppTextStyle.bodyMedium, FontWeight.bold),
            ),
            SizedBox(height: 8),
            FeatureChips(features: product.benefits!),
            SizedBox(height: 8),
          ],
          if (product.concern != null && product.concern!.isNotEmpty) ...[
            Text(
              "Concern",
              style: AppTextStyle.withWeight(
                  AppTextStyle.bodyMedium, FontWeight.bold),
            ),
            SizedBox(height: 8),
            FeatureChips(features: product.concern!),
          ],
        ],
      ),

      // Ingredients
      Padding(
        padding: EdgeInsets.only(right: 24),
        child: Text(product.ingredients ?? "No ingredients listed"),
      ),
    ];

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 24, top: 16, bottom: 24),
      child: AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: IndexedStack(
          index: _currentTabIndex,
          children: tabContents,
        ),
      ),
    );
  }

  Widget _buildFeatureContainer(String icon, String title, String subtitle) {
    return Container(
      width: 130,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Iconify(icon, size: 50, color: Color(0xFF2D3141)),
          SizedBox(height: 8),
          Text(title,
              style: AppTextStyle.withWeight(
                  AppTextStyle.bodyLarge, FontWeight.w600)),
          Text(subtitle),
        ],
      ),
    );
  }

  /// Bottom nav (alternatives section with filter button)
  // Revised bottom navigation that combines filtering with alternatives navigation
  Widget _buildBottomNavigation(Product product) {
    if (product.safe?.toLowerCase() == 'unsafe') {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Filter indicator with clear option
            if (_selectedFilters != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    // Icon(Icons.filter_list, size: 16, color: Colors.grey[600]),
                    // SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "Filters applied: ${_getFilterSummary(_selectedFilters!)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilters = null;
                        });
                      },
                      child: Text(
                        "Clear",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Action buttons
            Row(
              children: [
                // Show alternatives button
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _navigateToAlternatives,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _selectedFilters != null
                          ? "Show Filtered Alternatives"
                          : "Show Alternatives",
                      style: AppTextStyle.withWeight(
                          AppTextStyle.bodyMedium, FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                // Filter button
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: _openFilterModal,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.filter_list,
                          size: 20,
                          color: Colors.black,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Filter",
                          style: AppTextStyle.withWeight(
                              AppTextStyle.withColor(
                                  AppTextStyle.bodyMedium, Colors.black),
                              FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  String _getFilterSummary(FilterSelectionAlternative filters) {
    List<String> summary = [];

    // Rating range
    if (filters.ratingRange.start > 0 || filters.ratingRange.end < 5) {
      summary.add(
          "Rating ${filters.ratingRange.start.toInt()}-${filters.ratingRange.end.toInt()}");
    }

    // Skin types
    if (filters.skinTypes.isNotEmpty) {
      summary.add("${filters.skinTypes.length} skin types");
    }

    // Conditions
    if (filters.conditions.isNotEmpty) {
      summary.add("${filters.conditions.length} conditions");
    }

    // Countries
    if (filters.countries.isNotEmpty) {
      summary.add("${filters.countries.length} countries");
    }

    return summary.isEmpty ? "None" : summary.join(", ");
  }
}

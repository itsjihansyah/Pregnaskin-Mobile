import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:skincare/models/filter_selection_alternative.dart';
import 'package:skincare/models/product.dart';
import 'package:skincare/view/alternative_filter.dart';
import 'package:skincare/view/widget/alternative_chips.dart';
import 'package:skincare/view/widget/alternative_grid.dart';

import '../utils/app_textstyles.dart';

class AlternativePage extends StatefulWidget {
  final Product product;
  final FilterSelectionAlternative? initialFilters; // Added missing parameter

  const AlternativePage({
    super.key,
    required this.product,
    this.initialFilters, // Added parameter declaration
  });

  @override
  State<AlternativePage> createState() => _AlternativePageState();
}

class _AlternativePageState extends State<AlternativePage> {
  String selectedCategory = 'Match Features';
  FilterSelectionAlternative? appliedFilters;

  @override
  void initState() {
    super.initState();
    // Initialize appliedFilters with initialFilters if provided
    appliedFilters = widget.initialFilters;
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _openFilterScreen() async {
    final result = await showModalBottomSheet<FilterSelectionAlternative>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: FilterAlternative(initialFilters: appliedFilters),
      ),
    );

    if (result != null) {
      setState(() {
        appliedFilters = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
            size: 32,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        ),
        title: Text(
          "Alternatives",
          style: AppTextStyle.withWeight(AppTextStyle.h3, FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Iconify(MaterialSymbols.more_horiz, size: 28),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 4),
              child: Row(
                children: [
                  Expanded(
                    child: AlternativeChips(
                      categories: ['Match Features', 'Match Ingredients'],
                      selectedCategory: selectedCategory,
                      onCategorySelected: onCategorySelected,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AlternativeGrid(
                productId: widget.product.id,
                originalProduct: widget.product,
                filters: appliedFilters,
                category: selectedCategory,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

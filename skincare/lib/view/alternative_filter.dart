import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import '../models/product.dart';
import '../models/filter_selection_alternative.dart';
import '../utils/app_textstyles.dart';

class FilterAlternative extends StatefulWidget {
  final FilterSelectionAlternative? initialFilters;
  final Product? productContext; // New parameter to provide context

  const FilterAlternative({
    Key? key,
    this.initialFilters,
    this.productContext,
  }) : super(key: key);

  @override
  State<FilterAlternative> createState() => _FilterAlternativeState();
}

class _FilterAlternativeState extends State<FilterAlternative> {
  late FilterSelectionAlternative _filters;

  // Lists for filter options
  final List<String> _skinTypes = [
    'Dry',
    'Oily',
    'Sensitive',
  ];
  final List<String> _conditions = [
    'Acne',
    'Stretch Marks',
    'PIH',
    'Hyperpigmentation',
    'Melasma',
  ];
  final List<String> _countries = [
    'American',
    'Korean',
    'French',
    'British',
    'German',
    'Japanese',
    'Australian',
    'Swedish',
    'Canadian',
    'Indian',
    'Indonesian',
    'Spanish',
    'Filipino',
    'Swiss',
  ];

  @override
  void initState() {
    super.initState();

    // Initialize with either existing filters or defaults
    _filters = widget.initialFilters?.copy() ??
        FilterSelectionAlternative(
          ratingRange: RangeValues(0, 5),
          skinTypes: _getDefaultSkinTypes(),
          conditions: [],
          countries: [],
        );
  }

  // Intelligently suggest skin types based on original product
  List<String> _getDefaultSkinTypes() {
    if (widget.productContext == null) return [];

    List<String> defaults = [];

    if (widget.productContext!.dry_skin == true) defaults.add('Dry');
    if (widget.productContext!.oily_skin == true) defaults.add('Oily');
    if (widget.productContext!.sensitive_skin == true)
      defaults.add('Sensitive');

    // If no skin types are specifically indicated, we'll leave it blank
    return defaults;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRatingFilter(),
                  _buildDivider(),
                  _buildSkinTypeFilter(),
                  _buildDivider(),
                  _buildConditionsFilter(),
                  _buildDivider(),
                  _buildCountryFilter(),
                  SizedBox(
                    height: 24,
                  )
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFFAFAFA)),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Iconify(
                MaterialSymbols.close,
                size: 24,
                color: Colors.black,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
          Text(
            "Filter",
            style: AppTextStyle.withWeight(
                AppTextStyle.withColor(AppTextStyle.bodyMedium, Colors.black),
                FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rating",
                style: AppTextStyle.withWeight(
                    AppTextStyle.bodyLarge, FontWeight.w600),
              ),
              Text(
                "${_filters.ratingRange.start.round()} - ${_filters.ratingRange.end.round()}",
                style: AppTextStyle.bodyMedium,
              ),
            ],
          ),
        ),
        RangeSlider(
          min: 0,
          max: 5,
          divisions: 5,
          values: _filters.ratingRange,
          activeColor: Colors.black,
          inactiveColor: Color(0xFFFAFAFA),
          onChanged: (RangeValues values) {
            setState(() {
              _filters.ratingRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSkinTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Skin Type",
            style: AppTextStyle.withWeight(
                AppTextStyle.bodyLarge, FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _skinTypes.map((type) {
            final isSelected = _filters.skinTypes.contains(type);
            return FilterChip(
              label: Text(
                type,
                style: AppTextStyle.withColor(
                  isSelected
                      ? AppTextStyle.withWeight(
                          AppTextStyle.bodySmall, FontWeight.w600)
                      : AppTextStyle.bodySmall,
                  isSelected ? Colors.white : Colors.black,
                ),
              ),
              selected: isSelected,
              showCheckmark: false,
              backgroundColor: Color(0xFFFAFAFA),
              selectedColor: Colors.black,
              labelStyle: AppTextStyle.withColor(
                AppTextStyle.bodySmall,
                isSelected ? Colors.white : Colors.black,
              ),
              shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _filters.skinTypes.add(type);
                  } else {
                    _filters.skinTypes.remove(type);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConditionsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            "Condition",
            style: AppTextStyle.withWeight(
                AppTextStyle.bodyLarge, FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _conditions.map((condition) {
            final isSelected = _filters.conditions.contains(condition);
            return FilterChip(
              label: Text(
                condition,
                style: AppTextStyle.withColor(
                  isSelected
                      ? AppTextStyle.withWeight(
                          AppTextStyle.bodySmall, FontWeight.w600)
                      : AppTextStyle.bodySmall,
                  isSelected ? Colors.white : Colors.black,
                ),
              ),
              selected: isSelected,
              showCheckmark: false,
              backgroundColor: Color(0xFFFAFAFA),
              selectedColor: Colors.black,
              shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _filters.conditions.add(condition);
                  } else {
                    _filters.conditions.remove(condition);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCountryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Country",
                style: AppTextStyle.withWeight(
                    AppTextStyle.bodyLarge, FontWeight.w600),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                ),
                child: Text(
                  "See All",
                  style: AppTextStyle.withColor(
                      AppTextStyle.bodySmall, Colors.grey),
                ),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _countries.map((country) {
            final isSelected = _filters.countries.contains(country);
            return FilterChip(
              label: Text(
                country,
                style: AppTextStyle.withColor(
                  isSelected
                      ? AppTextStyle.withWeight(
                          AppTextStyle.bodySmall, FontWeight.w600)
                      : AppTextStyle.bodySmall,
                  isSelected ? Colors.white : Colors.black,
                ),
              ),
              selected: isSelected,
              showCheckmark: false,
              backgroundColor: Color(0xFFFAFAFA),
              selectedColor: Colors.black,
              shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _filters.countries.add(country);
                  } else {
                    _filters.countries.remove(country);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Color(0xFFFAFAFA),
      thickness: 1,
      height: 24,
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
              ),
              child: Text(
                "Reset",
                style: AppTextStyle.withColor(
                    AppTextStyle.bodyMedium, Colors.grey.shade700),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _filters),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Apply",
                style: AppTextStyle.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

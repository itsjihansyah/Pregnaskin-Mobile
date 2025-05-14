import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:skincare/models/filter.dart';
import 'package:skincare/models/filter_selection.dart';
import 'package:skincare/services/api_service.dart';
import 'package:skincare/utils/app_textstyles.dart';

class FilterHome extends StatefulWidget {
  final FilterSelection? initialFilters;

  const FilterHome({super.key, this.initialFilters});

  @override
  State<FilterHome> createState() => _FilterHomeState();
}

class _FilterHomeState extends State<FilterHome> {
  late RangeValues _currentRangeValues;
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedSkinTypes = {};
  final Set<String> _selectedConditions = {};
  final Set<String> _selectedSafety = {};
  final Set<String> _selectedCountries = {};

  @override
  void initState() {
    super.initState();

    if (widget.initialFilters != null) {
      _currentRangeValues = widget.initialFilters!.ratingRange;
      _selectedCategories.addAll(widget.initialFilters!.categories);
      _selectedSkinTypes.addAll(widget.initialFilters!.skinTypes);
      _selectedConditions.addAll(widget.initialFilters!.conditions);
      _selectedSafety.addAll(widget.initialFilters!.safetyOptions);
      _selectedCountries.addAll(widget.initialFilters!.countries);
    } else {
      _currentRangeValues = const RangeValues(0, 5);
    }
  }

  FilterSelection _getCurrentFilters() {
    return FilterSelection(
      ratingRange: _currentRangeValues,
      categories: _selectedCategories.toList(),
      skinTypes: _selectedSkinTypes.toList(),
      conditions: _selectedConditions.toList(),
      safetyOptions: _selectedSafety.toList(),
      countries: _selectedCountries.toList(),
    );
  }

  void _resetFilters() {
    setState(() {
      _currentRangeValues = const RangeValues(0, 5);
      _selectedCategories.clear();
      _selectedSkinTypes.clear();
      _selectedConditions.clear();
      _selectedSafety.clear();
      _selectedCountries.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRatingFilter(),
                      _buildDivider(),
                      _buildCategoryFilter(),
                      _buildDivider(),
                      _buildSkinTypeFilter(),
                      _buildDivider(),
                      _buildConditionFilter(),
                      _buildDivider(),
                      _buildSafetyFilter(),
                      _buildDivider(),
                      _buildCountryFilter(),
                      SizedBox(height: 24)
                    ],
                  ),
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFFAFAFA)),
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
              ),
              padding: EdgeInsets.zero,
            ),
          ),
          Text(
            "Filter",
            style: AppTextStyle.withWeight(AppTextStyle.h3, FontWeight.bold),
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
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rating",
                style: AppTextStyle.withWeight(
                    AppTextStyle.bodyLarge, FontWeight.w600),
              ),
              Text(
                "${_currentRangeValues.start.round()} - ${_currentRangeValues.end.round()}",
                style: AppTextStyle.bodyMedium,
              ),
            ],
          ),
        ),
        RangeSlider(
          min: 0,
          max: 5,
          divisions: 5,
          values: _currentRangeValues,
          activeColor: Colors.black,
          inactiveColor: const Color(0xFFFAFAFA),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = RangeValues(
                values.start.roundToDouble(),
                values.end.roundToDouble(),
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            "Category",
            style: AppTextStyle.withWeight(
                AppTextStyle.bodyLarge, FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return FilterChip(
              label: Text(
                category,
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
              backgroundColor: const Color(0xFFFAFAFA),
              shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
            );
          }).toList(),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget _buildSkinTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            "Skin Type",
            style: AppTextStyle.withWeight(
                AppTextStyle.bodyLarge, FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skinType.map((type) {
            final isSelected = _selectedSkinTypes.contains(type);
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
              backgroundColor: const Color(0xFFFAFAFA),
              selectedColor: Colors.black,
              shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedSkinTypes.add(type);
                  } else {
                    _selectedSkinTypes.remove(type);
                  }
                });
              },
            );
          }).toList(),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget _buildConditionFilter() {
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
          children: condition.map((item) {
            final isSelected = _selectedConditions.contains(item);
            return FilterChip(
              label: Text(
                item,
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
              backgroundColor: const Color(0xFFFAFAFA),
              selectedColor: Colors.black,
              shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedConditions.add(item);
                  } else {
                    _selectedConditions.remove(item);
                  }
                });
              },
            );
          }).toList(),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget _buildSafetyFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            "Safety",
            style: AppTextStyle.withWeight(
                AppTextStyle.bodyLarge, FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: safety.map((item) {
            final isSelected = _selectedSafety.contains(item);
            return FilterChip(
              label: Text(
                item,
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
              backgroundColor: const Color(0xFFFAFAFA),
              selectedColor: Colors.black,
              shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedSafety.add(item);
                  } else {
                    _selectedSafety.remove(item);
                  }
                });
              },
            );
          }).toList(),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget _buildCountryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                style:
                    AppTextStyle.withColor(AppTextStyle.bodySmall, Colors.grey),
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: topCountries.map((country) {
            final isSelected = _selectedCountries.contains(country);
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
              backgroundColor: const Color(0xFFFAFAFA),
              selectedColor: Colors.black,
              shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCountries.add(country);
                  } else {
                    _selectedCountries.remove(country);
                  }
                });
              },
            );
          }).toList(),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: const Color(0xFFFAFAFA),
      thickness: 1,
      height: 24,
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
              onPressed: _resetFilters,
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
              onPressed: () {
                final filters = _getCurrentFilters();
                Navigator.pop(context, filters);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
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

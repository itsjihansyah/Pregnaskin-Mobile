import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:skincare/utils/app_textstyles.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:skincare/models/filter.dart';

import 'package:skincare/view/widget/filter_chips.dart';

class FilterHome extends StatefulWidget {
  const FilterHome({super.key});

  @override
  State<FilterHome> createState() => _FilterHomeState();
}

class _FilterHomeState extends State<FilterHome> {
  RangeValues _currentRangeValues = const RangeValues(0, 5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              AppBar(
                scrolledUnderElevation: 0.0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Iconify(
                      MaterialSymbols.close,
                      size: 28,
                    ),
                  ),
                ],
                centerTitle: true,
                title: Text(
                  "Filter",
                  style: AppTextStyle.withWeight(AppTextStyle.h3, FontWeight.bold),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ratings Range", style: AppTextStyle.withWeight(AppTextStyle.bodyLarge, FontWeight.w600)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _currentRangeValues.start.round().toString(),
                              style: AppTextStyle.withWeight(AppTextStyle.bodyLarge, FontWeight.bold),
                            ),
                            Expanded(
                              child: RangeSlider(
                                values: _currentRangeValues,
                                min: 0.0,
                                max: 5.0,
                                divisions: 5,
                                labels: RangeLabels(
                                  _currentRangeValues.start.round().toString(),
                                  _currentRangeValues.end.round().toString(),
                                ),
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
                            ),
                            Text(
                              _currentRangeValues.end.round().toString(),
                              style: AppTextStyle.withWeight(AppTextStyle.bodyLarge, FontWeight.bold),
                            ),
                          ],
                        ),
                        _buildSection("Category", const FilterChips(filter: categories)),
                        _buildSection("Skin Type", const FilterChips(filter: skinType)),
                        _buildSection("Condition", const FilterChips(filter: condition)),
                        _buildSection("Safety", const FilterChips(filter: safety)),
                        const SizedBox(height: 8),
                        _buildCountrySelection(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: AppTextStyle.withWeight(AppTextStyle.bodyLarge, FontWeight.w600),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        child,
      ],
    );
  }

  Widget _buildCountrySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Country",
              style: AppTextStyle.withWeight(AppTextStyle.bodyLarge, FontWeight.w600),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.only(right: 0),
                minimumSize: Size(0, 0),
              ),
              child: Text("See All"),
            ),
          ],
        ),
        const FilterChips(filter: topCountries),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Reset Button
          TextButton(
            onPressed: () {
              // Reset action
            },
            child: Text(
              "Reset",
              style: AppTextStyle.withColor(AppTextStyle.bodyMedium, Colors.black),
            ),
          ),

          SizedBox(
            width: 230, // Adjust width as needed
            child: ElevatedButton(
              onPressed: () {
                // Apply action
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
                "Apply Filter",
                style: AppTextStyle.withWeight(AppTextStyle.bodyMedium, FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:skincare/utils/app_textstyles.dart';

class FeatureChips extends StatelessWidget {
  final String? features;
  const FeatureChips({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    List<String> categories = (features ?? "")
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (categories.isEmpty) {
      return SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(right: 24),
      child: Wrap(
        spacing: 8,
        runSpacing: 0,
        children: categories.map((feature) {
          return Chip(
            label: Text(
              feature,
              style: AppTextStyle.bodySmall,
            ),
            backgroundColor: Color(0xFFFAFAFA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.transparent),
            ),
          );
        }).toList(),
      ),
    );
  }
}

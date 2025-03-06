import 'package:flutter/material.dart';
import 'package:skincare/utils/app_textstyles.dart';
import 'package:skincare/models/product.dart';

class FeatureChips extends StatelessWidget {
  final String features; // The feature string from the product
  const FeatureChips({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    List<String> categories = features.split(',').map((e) => e.trim()).toList(); // Split and trim features

    return Padding(
      padding: EdgeInsets.only(right: 24), // Adjust as needed
      child: Wrap(
        spacing: 8, // Space between chips
        runSpacing: 0, // Space between rows
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

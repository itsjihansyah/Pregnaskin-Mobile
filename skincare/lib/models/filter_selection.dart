import 'package:flutter/material.dart';

class FilterSelection {
  final RangeValues ratingRange;
  final List<String> categories;
  final List<String> skinTypes;
  final List<String> conditions;
  final List<String> safetyOptions;
  final List<String> countries;

  FilterSelection({
    required this.ratingRange,
    required this.categories,
    required this.skinTypes,
    required this.conditions,
    required this.safetyOptions,
    required this.countries,
  });

  Map<String, dynamic> toJson() {
    return {
      'minRating': ratingRange.start,
      'maxRating': ratingRange.end,
      'categories': categories,
      'skin_types': skinTypes,
      'conditions': conditions,
      'safety_options': safetyOptions,
      'countries': countries,
    };
  }
}

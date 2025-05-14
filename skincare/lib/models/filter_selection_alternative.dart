import 'package:flutter/material.dart';

class FilterSelectionAlternative {
  RangeValues ratingRange;
  List<String> skinTypes;
  List<String> conditions;
  List<String> countries;

  FilterSelectionAlternative({
    required this.ratingRange,
    required this.skinTypes,
    required this.conditions,
    required this.countries,
  });

  // Method to create a deep copy
  FilterSelectionAlternative copy() {
    return FilterSelectionAlternative(
      ratingRange: RangeValues(ratingRange.start, ratingRange.end),
      skinTypes: List<String>.from(skinTypes),
      conditions: List<String>.from(conditions),
      countries: List<String>.from(countries),
    );
  }

  // Convert to JSON for API
  Map<String, dynamic> toJson() {
    // Only include min/max rating if they're not at the extremes
    Map<String, dynamic> json = {};

    if (ratingRange.start > 0) {
      json['minRating'] = ratingRange.start;
    }

    if (ratingRange.end < 5) {
      json['maxRating'] = ratingRange.end;
    }

    // Only include non-empty arrays
    if (skinTypes.isNotEmpty) {
      // Make sure all skin types are properly cased as the backend expects
      List<String> formattedSkinTypes = skinTypes.map((type) {
        // First letter uppercase, rest lowercase
        return type.substring(0, 1).toUpperCase() +
            type.substring(1).toLowerCase();
      }).toList();

      json['skin_types'] = formattedSkinTypes;
    }

    if (conditions.isNotEmpty) {
      json['conditions'] = conditions;
    }

    if (countries.isNotEmpty) {
      json['countries'] = countries;
    }

    return json;
  }

  // Check if filters are effectively empty/default
  bool get isEmpty {
    return ratingRange.start <= 0 &&
        ratingRange.end >= 5 &&
        skinTypes.isEmpty &&
        conditions.isEmpty &&
        countries.isEmpty;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FilterSelectionAlternative) return false;

    // Compare ranges with a small epsilon to account for floating point errors
    bool rangesEqual =
        (other.ratingRange.start - ratingRange.start).abs() < 0.01 &&
            (other.ratingRange.end - ratingRange.end).abs() < 0.01;

    // Compare lists (order doesn't matter)
    bool skinTypesEqual = other.skinTypes.length == skinTypes.length &&
        other.skinTypes.toSet().containsAll(skinTypes.toSet());

    bool conditionsEqual = other.conditions.length == conditions.length &&
        other.conditions.toSet().containsAll(conditions.toSet());

    bool countriesEqual = other.countries.length == countries.length &&
        other.countries.toSet().containsAll(countries.toSet());

    return rangesEqual && skinTypesEqual && conditionsEqual && countriesEqual;
  }

  @override
  int get hashCode =>
      ratingRange.start.hashCode ^
      ratingRange.end.hashCode ^
      skinTypes.toString().hashCode ^
      conditions.toString().hashCode ^
      countries.toString().hashCode;
}

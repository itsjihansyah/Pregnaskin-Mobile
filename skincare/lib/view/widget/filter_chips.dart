import 'package:flutter/material.dart';
import 'package:skincare/utils/app_textstyles.dart';

class FilterChips extends StatefulWidget {
  final List<String> filter;
  final Set<String> selectedFilters;
  final Function(String) onFilterSelected;
  final Function(String) onFilterUnselected;

  const FilterChips({
    super.key,
    required this.filter,
    required this.selectedFilters,
    required this.onFilterSelected,
    required this.onFilterUnselected,
  });

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        widget.filter.length,
        (index) {
          final filterValue = widget.filter[index];
          final isSelected = widget.selectedFilters.contains(filterValue);

          return ChoiceChip(
            label: Text(
              filterValue,
              style: AppTextStyle.withColor(
                isSelected
                    ? AppTextStyle.withWeight(
                        AppTextStyle.bodyMedium, FontWeight.w600)
                    : AppTextStyle.bodyMedium,
                isSelected ? Colors.white : Colors.black,
              ),
            ),
            selected: isSelected,
            onSelected: (bool selected) {
              if (selected) {
                widget.onFilterSelected(filterValue);
              } else {
                widget.onFilterUnselected(filterValue);
              }
            },
            selectedColor: Colors.black,
            backgroundColor: const Color(0xFFFAFAFA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: const BorderSide(
              color: Colors.transparent,
            ),
          );
        },
      ),
    );
  }
}

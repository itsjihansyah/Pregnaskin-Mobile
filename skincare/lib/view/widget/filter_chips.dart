import 'package:flutter/material.dart';
import 'package:skincare/utils/app_textstyles.dart';

class FilterChips extends StatefulWidget {
  final List<String> filter; // Accepts any filter type dynamically

  const FilterChips({super.key, required this.filter});

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  final Set<int> selectedIndices = {}; // Store multiple selected indices

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        widget.filter.length,
            (index) => ChoiceChip(
          label: Text(
            widget.filter[index],
            style: AppTextStyle.withColor(
              selectedIndices.contains(index)
                  ? AppTextStyle.withWeight(AppTextStyle.bodyMedium, FontWeight.w600)
                  : AppTextStyle.bodyMedium,
              selectedIndices.contains(index) ? Colors.white : Colors.black,
            ),
          ),
          selected: selectedIndices.contains(index),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                selectedIndices.add(index);
              } else {
                selectedIndices.remove(index);
              }
            });
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
        ),
      ),
    );
  }
}

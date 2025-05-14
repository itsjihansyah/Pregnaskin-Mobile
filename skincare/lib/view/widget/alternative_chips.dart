import 'package:flutter/material.dart';
import 'package:skincare/utils/app_textstyles.dart';

class AlternativeChips extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const AlternativeChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<AlternativeChips> createState() => _AlternativeChipsState();
}

class _AlternativeChipsState extends State<AlternativeChips> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          widget.categories.length,
          (index) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Center(
                  child: Text(
                    widget.categories[index],
                    style: AppTextStyle.withColor(
                      widget.selectedCategory == widget.categories[index]
                          ? AppTextStyle.withWeight(
                              AppTextStyle.bodySmall, FontWeight.w600)
                          : AppTextStyle.bodySmall,
                      widget.selectedCategory == widget.categories[index]
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                selected: widget.selectedCategory == widget.categories[index],
                onSelected: (bool selected) {
                  if (selected) {
                    widget.onCategorySelected(widget.categories[index]);
                  }
                },
                selectedColor: Colors.black,
                backgroundColor: const Color(0xFFFAFAFA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                labelPadding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

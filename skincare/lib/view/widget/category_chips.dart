import 'package:flutter/material.dart';
import 'package:skincare/utils/app_textstyles.dart';

class CategoryChips extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected; // Callback function

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    widget.onCategorySelected(
                        widget.categories[index]); // Notify parent
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

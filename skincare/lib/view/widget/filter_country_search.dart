import 'package:flutter/material.dart';
import 'package:skincare/utils/app_textstyles.dart';

import '../filter_home.dart';

class FilterCountrySearch extends StatefulWidget {
  const FilterCountrySearch({super.key});

  @override
  State<FilterCountrySearch> createState() => _FilterCountrySearchState();
}

class _FilterCountrySearchState extends State<FilterCountrySearch> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        focusNode: _focusNode,
        style: AppTextStyle.withColor(
          AppTextStyle.bodyMedium,
          Colors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Search country...',
          hintStyle: AppTextStyle.withColor(
            AppTextStyle.bodySmall,
            const Color(0xFFADB0BF),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: _isFocused ? Colors.black : const Color(0xFF979AAC),
          size: 24,),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.black),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}

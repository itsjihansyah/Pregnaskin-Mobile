import 'package:flutter/material.dart';
import 'package:skincare/utils/app_textstyles.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        focusNode: _focusNode, // Assign the focus node
        style: AppTextStyle.withColor(
          AppTextStyle.bodyMedium,
          Colors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Search Brand or Product...',
          hintStyle: AppTextStyle.withColor(
            AppTextStyle.bodyMedium,
            const Color(0xFFADB0BF),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: _isFocused ? Colors.black : const Color(0xFF979AAC),
          ),
          suffixIcon: Icon(
            Icons.tune,
            color: _isFocused ? Colors.black : const Color(0xFF979AAC),
          ),
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
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}

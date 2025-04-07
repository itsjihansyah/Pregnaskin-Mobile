import 'package:flutter/material.dart';
import 'package:skincare/utils/app_textstyles.dart';

import '../filter_home.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String)? onSearch;

  const CustomSearchBar({Key? key, this.onSearch}) : super(key: key);

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
        onSubmitted: widget.onSearch,
        focusNode: _focusNode,
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
          suffixIcon: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              icon: Icon(
                Icons.tune,
                color:
                    _isFocused ? Theme.of(context).colorScheme.onSurface : null,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (BuildContext context) {
                    return const FilterHome();
                  },
                );
              },
            ),
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

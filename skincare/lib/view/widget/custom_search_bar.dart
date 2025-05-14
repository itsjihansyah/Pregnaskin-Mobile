import 'package:flutter/material.dart';
import 'package:skincare/utils/app_textstyles.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final String initialValue;

  const CustomSearchBar({
    Key? key,
    required this.onSearch,
    this.initialValue = '',
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  void _clear() {
    _controller.clear();
    widget.onSearch('');
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        hintText: 'Search brands or products...',
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            Icons.search,
            size: 20,
            color: _isFocused ? Colors.black : Colors.grey,
          ),
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  size: 20,
                  color: _isFocused ? Colors.black : Colors.grey,
                ),
                onPressed: _clear,
              )
            : null,
        hintStyle: AppTextStyle.withColor(
          AppTextStyle.bodyMedium,
          Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onChanged: (_) => setState(() {}),
      onSubmitted: widget.onSearch,
    );
  }
}

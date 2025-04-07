import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:skincare/models/product.dart';
import 'package:skincare/view/widget/alternative_grid.dart'; // this one!

import '../utils/app_textstyles.dart';

class AlternativePage extends StatefulWidget {
  final Product product;

  const AlternativePage({super.key, required this.product});

  @override
  State<AlternativePage> createState() => _AlternativePageState();
}

class _AlternativePageState extends State<AlternativePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
            size: 32,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        ),
        title: Text(
          "Alternatives",
          style: AppTextStyle.withWeight(AppTextStyle.h3, FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Iconify(MaterialSymbols.more_horiz, size: 28),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: AlternativeGrid(productId: widget.product.id!),
      ),
    );
  }
}

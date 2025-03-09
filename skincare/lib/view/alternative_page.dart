import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:skincare/view/widget/category_chips.dart';
import 'package:skincare/view/widget/product_grid.dart';

import '../models/product.dart';
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
          icon: Icon(
            Icons.chevron_left_rounded,
            size: 32,
          ),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: 48,
            minHeight: 48, // Ensures accessibility
          ),
        ),
        title: Text(
          "Alternatives",
          style: AppTextStyle.withWeight(AppTextStyle.h3, FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Iconify(MaterialSymbols.more_horiz, size: 28),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
          child: Column(
            children: [
              //Search bar
              SizedBox(width: 0, height: 16),
              const CategoryChips(),
              SizedBox(width: 0, height: 16),
              const Expanded(child: ProductGrid())

            ],
          )),
    );
  }
}

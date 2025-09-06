import 'package:flutter/material.dart';
import 'package:skincare/view/alternative_detail.dart';
import 'package:skincare/view/widget/alternative_card.dart';

import '../../models/alternative_product.dart';

class AlternativeGrid extends StatelessWidget {
  final List<AlternativeProduct> alternativeProducts;

  const AlternativeGrid({super.key, required this.alternativeProducts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: alternativeProducts.length,
      itemBuilder: (context, index) {
        final product = alternativeProducts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlternativeDetail(alternativeProduct: product),
              ),
            );
          },
          child: AlternativeCard(alternativeProduct: product),
        );
      },
    );
  }
}

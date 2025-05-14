import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skincare/models/product.dart';
import 'package:skincare/view/items_detail.dart';
import 'package:skincare/view/widget/feature_chips.dart';
import '../models/alternative_product.dart';
import '../utils/app_textstyles.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';

class AlternativeDetail extends StatefulWidget {
  final AlternativeProduct alternativeProduct;
  final Product originalProduct;
  const AlternativeDetail(
      {super.key,
      required this.alternativeProduct,
      required this.originalProduct});

  @override
  State<AlternativeDetail> createState() => _AlternativeDetailState();
}

class _AlternativeDetailState extends State<AlternativeDetail>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Widget _buildFeatureContainer(String icon, String title, String subtitle) {
    return Container(
      width: 130,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Iconify(icon, size: 50, color: Color(0xFF2D3141)),
          SizedBox(height: 8),
          Text(title,
              style: AppTextStyle.withWeight(
                  AppTextStyle.bodyLarge, FontWeight.w600)),
          Text(subtitle),
        ],
      ),
    );
  }

  String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  Widget _buildComparisonRow({
    required String label,
    required String originalValue,
    required String alternativeValue,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column (original)
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyle.withWeight(
                        AppTextStyle.bodyMedium, FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    toTitleCase(originalValue),
                    style: AppTextStyle.withWeight(
                        AppTextStyle.bodyMedium, FontWeight.w400),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Right column (alternative)
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyle.withWeight(
                        AppTextStyle.bodyMedium, FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    toTitleCase(alternativeValue),
                    style: AppTextStyle.withWeight(
                        AppTextStyle.bodyMedium, FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left_rounded, size: 32),
        ),
        title: Text("Comparison",
            style: AppTextStyle.withWeight(AppTextStyle.h3, FontWeight.w600)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Iconify(MaterialSymbols.favorite_outline_rounded, size: 28),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: ListView(
        children: [
          // product image
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // unsafe product img
              Container(
                margin: EdgeInsets.symmetric(vertical: 24),
                padding: EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                height: size.height * 0.2,
                width: size.width * 0.4,
                child: widget.originalProduct?.image_url != null
                    ? Image.network(
                        widget.originalProduct!.image_url!,
                        fit: BoxFit.contain,
                      )
                    : Placeholder(),
              ),

              // VS Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.asset(
                  'assets/images/vs.png',
                  width: 32,
                  height: 32,
                ),
              ),

              // alternative product img
              Container(
                margin: EdgeInsets.symmetric(vertical: 24),
                padding: EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                height: size.height * 0.2,
                width: size.width * 0.4,
                child: Image.network(
                  widget.alternativeProduct.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),

          // Product details
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ori product name rating and brand
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.originalProduct.brand,
                        style: AppTextStyle.withColor(
                          AppTextStyle.withWeight(
                              AppTextStyle.bodyMedium, FontWeight.w400),
                          Colors.black,
                        ),
                      ),
                      Text(
                        widget.originalProduct.name,
                        style: AppTextStyle.withColor(
                          AppTextStyle.withWeight(
                              AppTextStyle.bodyLarge, FontWeight.w600),
                          Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Color(0xFFF3BB2D), size: 16),
                          SizedBox(width: 4),
                          Text(
                            widget.originalProduct.rating?.toStringAsFixed(1) ??
                                '0.0',
                            style: AppTextStyle.withWeight(
                                AppTextStyle.bodyMedium, FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                SizedBox(width: 16),

                // alternative name rating and brand
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.alternativeProduct.brand,
                        style: AppTextStyle.withColor(
                          AppTextStyle.withWeight(
                              AppTextStyle.bodyMedium, FontWeight.w400),
                          Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemsDetail(
                                productId: widget.alternativeProduct.id,
                                product: widget.alternativeProduct,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          widget.alternativeProduct.name,
                          style: AppTextStyle.withColor(
                            AppTextStyle.withWeight(
                              AppTextStyle.bodyLarge,
                              FontWeight.w600,
                            ),
                            Colors.black,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Color(0xFFF3BB2D), size: 16),
                          SizedBox(width: 4),
                          Text(
                            widget.alternativeProduct.rating
                                    ?.toStringAsFixed(1) ??
                                '0.0',
                            style: AppTextStyle.withWeight(
                                AppTextStyle.bodyMedium, FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Match ingredients and features info
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Image.asset(
                    'assets/images/ingredients.png',
                    height: 38,
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Match Ingredients',
                      style: AppTextStyle.withColor(
                          AppTextStyle.bodySmall, Colors.black),
                    ),
                    Text(
                      '${widget.alternativeProduct.matchIngredients} Ingredients',
                      style: AppTextStyle.withWeight(
                          AppTextStyle.bodyLarge, FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(width: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Image.asset(
                    'assets/images/features.png',
                    height: 28,
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Match Features',
                      style: AppTextStyle.withColor(
                          AppTextStyle.bodySmall, Colors.black),
                    ),
                    Text(
                      '${widget.alternativeProduct.matchPercentage}% Match',
                      style: AppTextStyle.withWeight(
                          AppTextStyle.bodyLarge, FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // detailed information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildComparisonRow(
                  label: 'Classification',
                  originalValue: widget.originalProduct.safe ?? 'Unknown',
                  alternativeValue: widget.alternativeProduct.safe,
                ),
                _buildComparisonRow(
                  label: 'Skin Types',
                  originalValue: [
                    if (widget.originalProduct.oily_skin == true) 'Oily skin',
                    if (widget.originalProduct.dry_skin == true) 'Dry skin',
                    if (widget.originalProduct.sensitive_skin == true)
                      'Sensitive skin',
                  ].join(', '),
                  alternativeValue: [
                    if (widget.alternativeProduct.oily_skin == true)
                      'Oily skin',
                    if (widget.alternativeProduct.dry_skin == true) 'Dry skin',
                    if (widget.alternativeProduct.sensitive_skin == true)
                      'Sensitive skin',
                  ].join(', '),
                ),
                _buildComparisonRow(
                  label: 'Pregnancy Condition',
                  originalValue:
                      widget.originalProduct.pregnancy_condition?.isEmpty ??
                              true
                          ? 'None'
                          : widget.originalProduct.pregnancy_condition!,
                  alternativeValue:
                      widget.alternativeProduct.pregnancy_condition?.isEmpty ??
                              true
                          ? 'None'
                          : widget.alternativeProduct.pregnancy_condition!,
                ),
                _buildComparisonRow(
                  label: 'Benefits',
                  originalValue:
                      widget.originalProduct.benefits?.isEmpty ?? true
                          ? 'None'
                          : widget.originalProduct.benefits!,
                  alternativeValue:
                      widget.alternativeProduct.benefits?.isEmpty ?? true
                          ? 'None'
                          : widget.alternativeProduct.benefits!,
                ),
                _buildComparisonRow(
                  label: 'Concern',
                  originalValue: widget.originalProduct.concern?.isEmpty ?? true
                      ? 'None'
                      : widget.originalProduct.concern!,
                  alternativeValue:
                      widget.alternativeProduct.concern?.isEmpty ?? true
                          ? 'None'
                          : widget.alternativeProduct.concern!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skincare/models/product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skincare/utils/app_textstyles.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      constraints: BoxConstraints(
        maxWidth: screenWidth * 0.9,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(aspectRatio: 4/3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(product.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
              ),
              ),

              // Safe button
              Positioned(
                right: 8,
                top: 2,
                child: Chip(
                  label: Text(
                    product.safe,
                    style: AppTextStyle.withColor(
                      AppTextStyle.bodySmall,
                      Colors.white,
                    ),
                  ),
                  backgroundColor: product.safe.toLowerCase() == 'safe' ? Colors.black : Color(0xFF979AAC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: const BorderSide(
                    color: Colors.transparent,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),

          // product details
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brand,
                  style: AppTextStyle.withColor(AppTextStyle.bodySmall, Color(0xFF979AAC)),
                  maxLines: 1,
                ),
                SizedBox(height: screenWidth*0.01),
                Text(
                  product.name,
                  style: AppTextStyle.withColor(AppTextStyle.withWeight(AppTextStyle.bodyLarge, FontWeight.w600), Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenWidth * 0.01),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFF979AAC), size: 16,),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        Text(product.rating.toStringAsFixed(1), style: AppTextStyle.withColor(AppTextStyle.bodySmall, Color(0xFF979AAC))),
                      ],
                    ),
                    SizedBox(width: screenWidth * 0.02, height: 0),
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.earthAsia, color: Color(0xFF979AAC), size: 12),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        Text(product.country, style: AppTextStyle.withColor(AppTextStyle.bodySmall, Color(0xFF979AAC))),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

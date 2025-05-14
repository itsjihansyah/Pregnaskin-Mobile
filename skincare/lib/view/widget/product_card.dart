import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skincare/models/product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skincare/utils/app_textstyles.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    product.image_url ??
                        'https://skinsort.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsiZGF0YSI6MTA5ODgyMiwicHVyIjoiYmxvYl9pZCJ9fQ==--e0c198ba1c55c1756b6b5ded3f85f660f3a56171/eyJfcmFpbHMiOnsiZGF0YSI6eyJmb3JtYXQiOiJ3ZWJwIiwicmVzaXplX3RvX2xpbWl0IjpbMTAwMCwxMDAwXSwic2F2ZXIiOnsicXVhbGl0eSI6NzB9fSwicHVyIjoidmFyaWF0aW9uIn19--32d30009c4c42be30fe9b77eaeb5b1ae073dd99a/IMG_2842.jpeg',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fitHeight,
                    errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey),
                  ),
                ),
              ),

              // Safe button
              Positioned(
                right: 8,
                top: 2,
                child: Chip(
                  label: Text(
                    product.safe ?? 'Unknown',
                    style: AppTextStyle.withColor(
                      AppTextStyle.bodySmall,
                      Colors.white,
                    ),
                  ),
                  backgroundColor: (product.safe ?? '').toLowerCase() == 'safe'
                      ? Colors.black
                      : Color(0xFF979AAC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: const BorderSide(
                    color: Colors.transparent,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),

          // Product details
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brand,
                  style: AppTextStyle.withColor(
                      AppTextStyle.bodySmall, Color(0xFF979AAC)),
                  maxLines: 1,
                ),
                SizedBox(height: screenWidth * 0.01),
                Text(
                  product.name,
                  style: AppTextStyle.withColor(
                      AppTextStyle.withWeight(
                          AppTextStyle.bodyLarge, FontWeight.w600),
                      Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenWidth * 0.01),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFF979AAC), size: 16),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        Text(
                          product.rating != null
                              ? product.rating!.toStringAsFixed(1)
                              : 'N/A',
                          style: AppTextStyle.withColor(
                              AppTextStyle.bodySmall, Color(0xFF979AAC)),
                        ),
                      ],
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.earthAsia,
                            color: Color(0xFF979AAC), size: 12),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        Text(
                          product.country ?? 'Unknown Country',
                          style: AppTextStyle.withColor(
                              AppTextStyle.bodySmall, Color(0xFF979AAC)),
                        ),
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

// Fetch API
Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/products'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => Product.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}

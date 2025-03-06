import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skincare/view/widget/feature_chips.dart';
import '../../models/product.dart';
import '../utils/app_textstyles.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';



class ItemsDetail extends StatefulWidget {
  final Product product;
  const ItemsDetail({super.key, required this.product});

  @override
  State<ItemsDetail> createState() => _ItemsDetailState();
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
        Text(title, style: AppTextStyle.withWeight(AppTextStyle.bodyLarge, FontWeight.w600)),
        Text(subtitle),
      ],
    ),
  );
}

class _ItemsDetailState extends State<ItemsDetail>
    with TickerProviderStateMixin {
  String unsafe_reason = 'Titanium Dioxide';
  double dynamicHeight = 300; // Default height

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
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
          "Detail",
          style: AppTextStyle.withWeight(AppTextStyle.h3, FontWeight.w600),
        ),
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
          Container(
            margin: EdgeInsets.only(top: 24),
            color: Colors.white,
            height: size.height * 0.34,
            width: size.width,
            child: Column(
              children: [
                Image.network(
                  widget.product.imageUrl,
                  height: size.height * 0.3,
                  width: size.width * 0.85,
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text(
                    widget.product.safe,
                    style: AppTextStyle.withColor(
                        AppTextStyle.bodyMedium, Colors.white),
                  ),
                  backgroundColor: widget.product.safe.toLowerCase() == 'safe'
                      ? Colors.black
                      : Color(0xFF979AAC),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  side: const BorderSide(color: Colors.transparent),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                SizedBox(height: size.width * 0.01),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.product.name,
                        style: AppTextStyle.withColor(
                          AppTextStyle.withWeight(
                              AppTextStyle.h2, FontWeight.w600),
                          Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),
                    Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFF3BB2D), size: 26),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        Text(widget.product.rating.toString(),
                            style: AppTextStyle.withWeight(
                                AppTextStyle.bodyLarge, FontWeight.w600)),
                      ],
                    )
                  ],
                ),
                SizedBox(height: size.height * 0.001),
                Text(
                  widget.product.brand,
                  style: AppTextStyle.withColor(
                      AppTextStyle.bodyLarge, Color(0xFF979AAC)),
                  maxLines: 1,
                ),
                SizedBox(height: size.height * 0.001),


                // Unsafe Reason Box
                widget.product.safe.toLowerCase() == 'unsafe'
                    ? Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  decoration: BoxDecoration(
                    color: Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Iconify(MaterialSymbols.warning_outline_rounded, color: Colors.black, size: 43),
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Unsafe:',
                              style: AppTextStyle.withColor(
                                  AppTextStyle.bodySmall, Colors.black),
                            ),
                            Text(
                              'Containing $unsafe_reason',
                              style: AppTextStyle.withWeight(
                                  AppTextStyle.bodyLarge, FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                    : SizedBox(height: size.height * 0.01),

              ],
            ),
          ),

          // Tab Bar
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  dividerColor: Colors.transparent,
                  overlayColor: MaterialStateProperty.all(Color(0xFFFAFAFA)),
                  splashFactory: InkRipple.splashFactory,
                  indicatorColor: Colors.black,
                  labelStyle: AppTextStyle.withWeight(AppTextStyle.bodyMedium, FontWeight.bold),
                  unselectedLabelStyle: AppTextStyle.withWeight(AppTextStyle.bodyMedium, FontWeight.w400),
                  tabs: [
                    Tab(text: "Overview"),
                    Tab(text: "Features"),
                    Tab(text: "Ingredients"),
                  ],
                ),
              ),
              Container(
                height: 300,
                margin: EdgeInsets.only(left: 24, top: 24, bottom: 24),
                child: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Column(
                      children: [
                        Padding(padding: EdgeInsets.only(right: 24), child: Text(widget.product.description),),
                        SizedBox(height: 24),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(right: 24),
                          child: Row(
                            children: [
                              _buildFeatureContainer(Mdi.earth, widget.product.country, "Product"),
                              SizedBox(width: 12),
                              _buildFeatureContainer(MaterialSymbols.cool_to_dry_outline, "Dry", "Skin"),
                              SizedBox(width: 12),
                              _buildFeatureContainer(Ph.drop_half_bottom, "Oily", "Skin"),
                              SizedBox(width: 12),
                              _buildFeatureContainer(Ph.egg_crack, "Sensitive", "Skin"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Benefits",
                          style: AppTextStyle.withWeight(AppTextStyle.bodyMedium, FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        FeatureChips(features: widget.product.feature),
                        SizedBox(height: 8),
                        Text(
                          "Concern",
                          style: AppTextStyle.withWeight(AppTextStyle.bodyMedium, FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        FeatureChips(features: widget.product.feature),// Pass the feature string
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(right: 24), child: Text(widget.product.ingredients),),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

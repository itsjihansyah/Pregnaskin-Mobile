import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skincare/view/widget/category_chips.dart';
import 'package:skincare/view/widget/custom_search_bar.dart';
import 'package:skincare/view/widget/product_card.dart';
import 'package:skincare/view/widget/product_grid.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  String selectedCategory = 'Popular';
  String searchQuery = '';

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning ⛅',
                        style: TextStyle(
                          color: Color(0xFF979AAC),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Jihan Syahira',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.favorite_outline)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_outlined))
                ],
              ),
            ),
            // Search bar
            CustomSearchBar(
              onSearch: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),

            const SizedBox(height: 16),
            CategoryChips(
              categories: ['Popular', 'For You', 'Latest'],
              selectedCategory: selectedCategory,
              onCategorySelected: onCategorySelected,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ProductGrid(
                selectedCategory: selectedCategory,
                searchQuery: searchQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

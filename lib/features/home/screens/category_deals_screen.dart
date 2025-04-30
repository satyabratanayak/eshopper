import 'package:eshopper/common/widgets/product_card.dart';
import 'package:eshopper/constants/global_variables.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/features/home/services/home_services.dart';
import 'package:eshopper/features/product_details/screens/product_details_screen.dart';
import 'package:eshopper/models/product.dart';
import 'package:flutter/material.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String category;
  const CategoryDealsScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  List<Product> productList = [];
  final HomeServices homeServices = HomeServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Text(
            widget.category,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: productList.isEmpty
          ? Center(
              child: Text(
                StringConstants.noProductsInCategory,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  productList.length,
                  (index) {
                    final product = productList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ProductDetailScreen.routeName,
                          arguments: product,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5),
                        width: MediaQuery.of(context).size.width / 2 - 12,
                        child: ProductCard(
                          cardType: CardType.vertical,
                          product: product,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  fetchCategoryProducts() async {
    productList = await homeServices.fetchCategoryProducts(
      context: context,
      category: widget.category,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }
}

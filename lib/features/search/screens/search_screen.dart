import 'package:eshopper/common/widgets/custom_appbar.dart';
import 'package:eshopper/common/widgets/loader.dart';
import 'package:eshopper/common/widgets/product_card.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/features/home/widgets/address_box.dart';
import 'package:eshopper/features/product_details/screens/product_details_screen.dart';
import 'package:eshopper/features/search/services/search_services.dart';
import 'package:eshopper/models/product.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';
  final String searchQuery;
  const SearchScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product>? products;
  final SearchServices searchServices = SearchServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: products == null
          ? const Loader()
          : products!.isEmpty
              ? Center(
                  child: Text(
                    StringConstants.noProducts,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : Column(
                  children: [
                    const AddressBox(),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: products!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ProductDetailScreen.routeName,
                                arguments: products![index],
                              );
                            },
                            child: ProductCard(
                              product: products![index],
                              autoScroll: false,
                              cardType: CardType.horizontal,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  fetchSearchedProduct() async {
    products = await searchServices.fetchSearchedProduct(
        context: context, searchQuery: widget.searchQuery);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchSearchedProduct();
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }
}

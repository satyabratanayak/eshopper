import 'package:eshopper/common/widgets/custom_appbar.dart';
import 'package:eshopper/common/widgets/loader.dart';
import 'package:eshopper/common/widgets/product_card.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/features/product_details/screens/product_details_screen.dart';
import 'package:eshopper/features/search/screens/search_screen.dart';
import 'package:eshopper/features/wishlist/services/wishlist_services.dart';
import 'package:eshopper/models/product.dart';
import 'package:flutter/material.dart';

class Wishlist extends StatefulWidget {
  static const routeName = '/your-wishlist';
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => WishlistState();
}

class WishlistState extends State<Wishlist> {
  final WishlistServices wishlistServices = WishlistServices();
  List<Product>? wishlist;

  @override
  Widget build(BuildContext context) {
    final currentWishlist = wishlist;
    return Scaffold(
      appBar: CustomAppBar(),
      body: currentWishlist == null
          ? const Loader()
          : currentWishlist.isEmpty
              ? const Center(
                  child: Text(
                    StringConstants.noWishlist,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          StringConstants.wishlist,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          currentWishlist.length,
                          (index) {
                            final orderData = currentWishlist[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  ProductDetailScreen.routeName,
                                  arguments: orderData,
                                );
                              },
                              child: SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 12,
                                child: ProductCard(
                                  cardType: CardType.vertical,
                                  product: orderData,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void fetchWishlist() async {
    wishlist = await wishlistServices.fetchMyWishlist(context: context);
    setState(() {});
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }
}

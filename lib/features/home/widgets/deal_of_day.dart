import 'package:eshopper/common/widgets/loader.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/features/home/services/home_services.dart';
import 'package:eshopper/features/product_details/screens/product_details_screen.dart';
import 'package:eshopper/models/product.dart';
import 'package:flutter/material.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({super.key});

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  Product product = Product.empty();
  List<Product> products = [];
  final HomeServices homeServices = HomeServices();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loader()
        : product.name.isEmpty
            ? const SizedBox()
            : GestureDetector(
                onTap: navigateToDetailScreen,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      child: const Text(
                        StringConstants.dealOfTheDay,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Image.network(
                      product.images[0],
                      height: 235,
                      fit: BoxFit.fitHeight,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      alignment: Alignment.topLeft,
                      child: Text(
                        '₹${product.price}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                          const EdgeInsets.only(left: 15, top: 5, right: 40),
                      child: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: product.images
                            .map(
                              (e) => Image.network(
                                e,
                                fit: BoxFit.fitWidth,
                                width: 100,
                                height: 100,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ).copyWith(left: 15),
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: fetchAllProducts,
                        child: Text(
                          StringConstants.seeAllDeals,
                          style: TextStyle(
                            color: Colors.cyan[800],
                          ),
                        ),
                      ),
                    ),
                    if (products.isNotEmpty)
                      ListView.builder(
                        itemCount: products.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(products[index].name),
                            subtitle: Text('₹${products[index].price}'),
                            leading: Image.network(
                              products[index].images[0],
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          );
                        },
                      )
                  ],
                ),
              );
  }

  void fetchAllProducts() async {
    setState(() {
      isLoading = true;
    });
    products = await homeServices.fetchAllProducts(context: context);
    setState(() {
      isLoading = false;
    });
  }

  void fetchDealOfDay() async {
    setState(() {
      isLoading = true;
    });
    product = await homeServices.fetchDealOfDay(context: context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDealOfDay();
  }

  void navigateToDetailScreen() {
    Navigator.pushNamed(
      context,
      arguments: product,
      ProductDetailScreen.routeName,
    );
  }
}

import 'package:eshopper/common/widgets/loader.dart';
import 'package:eshopper/common/widgets/product_card.dart';
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      child: const Text(
                        StringConstants.dealOfTheDay,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 235,
                      child: Image.network(
                        product.images[0],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '₹${product.price}',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15)
                          .copyWith(left: 15),
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: fetchAllProducts,
                        child: Text(
                          StringConstants.seeAllDeals,
                          style: TextStyle(
                            color: Colors.teal,
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
                      ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Expanded(child: ProductCard(product: products[0])),
                          Expanded(child: ProductCard(product: products[1])),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Expanded(child: ProductCard(product: products[2])),
                          Expanded(child: ProductCard(product: products[3])),
                        ],
                      ),
                    ),
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
    fetchAllProducts();
  }

  void navigateToDetailScreen() {
    Navigator.pushNamed(
      context,
      arguments: product,
      ProductDetailScreen.routeName,
    );
  }
}

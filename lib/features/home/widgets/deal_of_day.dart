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
  List<Product> products = [];
  late int length;
  final HomeServices homeServices = HomeServices();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loader()
        : products[0].name.isEmpty
            ? const SizedBox()
            : Column(
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
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(
                        products.length,
                        (index) => GestureDetector(
                          onTap: () => navigateToDetailScreen(index),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 12,
                            child: ProductCard(
                              cardType: CardType.vertical,
                              product: products[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (products.length > 4 && length == 4)
                    Container(
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            length = products.length;
                          });
                        },
                        child: Text(
                          StringConstants.seeAllDeals,
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                    ),
                ],
              );
  }

  void fetchDealOfDay() async {
    setState(() {
      isLoading = true;
    });
    products = await homeServices.fetchDealOfDay(context: context);
    length = products.length > 4 ? 4 : products.length;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDealOfDay();
  }

  void navigateToDetailScreen(int index) {
    Navigator.pushNamed(
      context,
      arguments: products[index],
      ProductDetailScreen.routeName,
    );
  }
}

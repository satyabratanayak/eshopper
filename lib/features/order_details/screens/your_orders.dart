import 'package:eshopper/common/widgets/custom_appbar.dart';
import 'package:eshopper/common/widgets/loader.dart';
import 'package:eshopper/common/widgets/product_card.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/features/account/services/account_services.dart';
import 'package:eshopper/features/order_details/screens/order_details.dart';
import 'package:eshopper/features/search/screens/search_screen.dart';
import 'package:eshopper/models/order.dart';
import 'package:flutter/material.dart';

class YourOrdersScreen extends StatefulWidget {
  static const routeName = '/your-orders';
  const YourOrdersScreen({super.key});

  @override
  State<YourOrdersScreen> createState() => _YourOrdersScreenState();
}

class _YourOrdersScreenState extends State<YourOrdersScreen> {
  final AccountServices accountServices = AccountServices();
  List<Order>? orders;

  @override
  Widget build(BuildContext context) {
    final currentOrders = orders;
    return Scaffold(
      appBar: CustomAppBar(),
      body: currentOrders == null
          ? const Loader()
          : currentOrders.isEmpty
              ? const Center(
                  child: Text(
                    StringConstants.noOrders,
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
                          StringConstants.yourOrders,
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
                          currentOrders.length,
                          (index) {
                            final orderData = currentOrders[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  OrderDetailScreen.routeName,
                                  arguments: orderData,
                                );
                              },
                              child: SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 12,
                                child: ProductCard(
                                  cardType: CardType.vertical,
                                  product: orderData.products[0],
                                  totalProducts:
                                      orderData.products.length.toDouble(),
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

  void fetchOrders() async {
    orders = await accountServices.fetchMyOrders(context: context);
    setState(() {});
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }
}

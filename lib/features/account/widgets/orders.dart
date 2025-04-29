import 'package:eshopper/common/widgets/loader.dart';
import 'package:eshopper/common/widgets/product_card.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/features/account/services/account_services.dart';
import 'package:eshopper/features/order_details/screens/order_details.dart';
import 'package:eshopper/models/order.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  List<Order> undeliveredOrders = [];

  final AccountServices accountServices = AccountServices();

  @override
  Widget build(BuildContext context) {
    if (orders != null) {
      undeliveredOrders = orders!.where((order) => order.status < 3).toList();
    }

    return orders == null
        ? Loader()
        : undeliveredOrders.isEmpty
            ? Center(
                child: Text(
                  StringConstants.noOrders,
                  style: TextStyle(fontSize: 16),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text(
                      StringConstants.pendingOrders,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      undeliveredOrders.length,
                      (index) {
                        final order = undeliveredOrders[index];
                        final products = order.products;
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              OrderDetailScreen.routeName,
                              arguments: order,
                            );
                          },
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width / 2 - 12,
                              child: ProductCard(
                                cardType: CardType.vertical,
                                product: products[0],
                                totalProducts: order.products.length.toDouble(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
  }

  void fetchOrders() async {
    orders = await accountServices.fetchMyOrders(context: context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }
}

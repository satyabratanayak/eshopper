import 'package:eshopper/common/widgets/loader.dart';
import 'package:eshopper/constants/global_variables.dart';
import 'package:eshopper/features/account/services/account_services.dart';
import 'package:eshopper/features/account/widgets/single_product.dart';
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
  final AccountServices accountServices = AccountServices();

  @override
  Widget build(BuildContext context) {
    if (orders == null) {
      return const Loader(); // Still loading
    }

    if (orders!.isEmpty) {
      return const Center(
        child: Text(
          "You have no orders yet.",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'See all',
                style: TextStyle(
                  color: GlobalVariables.selectedNavBarColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Order List
        SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: orders!.length,
            itemBuilder: (context, index) {
              final order = orders![index];
              final products = order.products;
              String? image;
              if (products.isNotEmpty && products[0].images.isNotEmpty) {
                image = products[0].images[0];
              }

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    OrderDetailScreen.routeName,
                    arguments: order,
                  );
                },
                child: SingleProduct(
                  image: image ??
                      'https://karanzi.websites.co.in/obaju-turquoise/img/product-placeholder.png',
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

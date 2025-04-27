import 'package:eshopper/common/widgets/loader.dart';
import 'package:eshopper/common/widgets/product_card.dart';
import 'package:eshopper/features/admin/services/admin_services.dart';
import 'package:eshopper/features/order_details/screens/order_details.dart';
import 'package:eshopper/models/order.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order>? orders;
  final AdminServices adminServices = AdminServices();

  @override
  Widget build(BuildContext context) {
    final currentOrders = orders;
    return currentOrders == null
        ? const Loader()
        : Padding(
            padding: const EdgeInsets.all(5),
            child: Wrap(
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
                      width: MediaQuery.of(context).size.width / 2 - 12,
                      child: ProductCard(
                        cardType: CardType.vertical,
                        product: orderData.products[0],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }

  void fetchOrders() async {
    orders = await adminServices.fetchAllOrders(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }
}

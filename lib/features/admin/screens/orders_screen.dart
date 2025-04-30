import 'package:eshopper/common/widgets/loader.dart';
import 'package:eshopper/common/widgets/product_card.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/features/admin/services/admin_services.dart';
import 'package:eshopper/features/order_details/screens/order_details.dart';
import 'package:eshopper/models/order.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  List<Order>? orders;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await adminServices.fetchAllOrders(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentOrders = orders;

    if (currentOrders == null) return const Loader();

    final pendingOrders =
        currentOrders.where((order) => order.status < 3).toList();

    final completedOrders =
        currentOrders.where((order) => order.status >= 3).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            dividerColor: Colors.grey[200],
            tabs: [
              Tab(text: StringConstants.pendingOrders),
              Tab(text: StringConstants.completedOrders),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildOrderGrid(pendingOrders),
            buildOrderGrid(completedOrders),
          ],
        ),
      ),
    );
  }

  Widget buildOrderGrid(List<Order> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text(StringConstants.zeroOrders));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(
          orders.length,
          (index) {
            final orderData = orders[index];
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
}

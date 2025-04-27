import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart.map((e) {
      int price = e.product.price.toInt();
      sum += e.quantity * (price <= 150 ? price + 50 : price);
    }).toList();

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            StringConstants.subTotal,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            ' ₹$sum',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

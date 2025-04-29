import 'package:eshopper/common/widgets/custom_appbar.dart';
import 'package:eshopper/common/widgets/custom_button.dart';
import 'package:eshopper/common/widgets/product_card.dart';
import 'package:eshopper/constants/global_variables.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/features/address/screens/address_screen.dart';
import 'package:eshopper/features/cart/widgets/cart_subtotal.dart';
import 'package:eshopper/features/home/widgets/address_box.dart';
import 'package:eshopper/features/search/screens/search_screen.dart';
import 'package:eshopper/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart.map((e) {
      int price = e.product.price.toInt();
      sum += e.quantity * (price <= 150 ? price + 50 : price);
    }).toList();

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressBox(),
            const CartSubtotal(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text:
                    '${StringConstants.proceedToBuy} (${user.cart.length} ${StringConstants.items})',
                onTap: () => navigateToAddress(sum),
                color: GlobalVariables.secondaryColor,
                isEnabled: user.cart.isNotEmpty,
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: user.cart.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final productCart =
                    context.watch<UserProvider>().user.cart[index];
                return ProductCard(
                  cardType: CardType.horizontal,
                  product: productCart.product,
                  quantity: productCart.quantity,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void navigateToAddress(int sum) {
    Navigator.pushNamed(
      context,
      AddressScreen.routeName,
      arguments: sum.toString(),
    );
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }
}

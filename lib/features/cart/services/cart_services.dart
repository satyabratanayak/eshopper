import 'dart:convert';

import 'package:eshopper/constants/error_handling.dart';
import 'package:eshopper/constants/global_variables.dart';
import 'package:eshopper/constants/utils.dart';
import 'package:eshopper/models/product.dart';
import 'package:eshopper/models/user.dart';
import 'package:eshopper/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CartServices {
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-from-cart/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      if (!context.mounted) return;
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final cartJson = jsonDecode(res.body)['cart'];
          final cartItems = List<CartItem>.from(
            cartJson.map((item) => CartItem.fromMap(item)),
          );

          final updatedUser = userProvider.user.copyWith(cart: cartItems);

          userProvider.setUserFromModel(updatedUser);
        },
      );
    } catch (e) {
      showGlobalSnackBar(e.toString());
    }
  }
}

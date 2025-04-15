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

class AddressServices {
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // try {
    http.Response res = await http.post(
      Uri.parse('$uri/api/save-user-address'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
      body: jsonEncode({
        'address': address,
      }),
    );
    if (!context.mounted) return;
    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        User user = userProvider.user.copyWith(
          address: jsonDecode(res.body)['address'],
        );

        userProvider.setUserFromModel(user);
      },
    );
    // } catch (e) {
    //   showGlobalSnackBar(e.toString());
    // }
  }

  // get all the products
  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // try {
    http.Response res = await http.post(Uri.parse('$uri/api/order'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'cart': userProvider.user.cart,
          'address': address,
          'totalPrice': totalSum,
        }));
    if (!context.mounted) return;
    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        showGlobalSnackBar('Your order has been placed!');
        User user = userProvider.user.copyWith(
          cart: [],
        );
        userProvider.setUserFromModel(user);
      },
    );
    // } catch (e) {
    //   showGlobalSnackBar(e.toString());
    // }
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // try {
    http.Response res = await http.post(
      Uri.parse('$uri/admin/delete-product'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
      body: jsonEncode({
        'id': product.id,
      }),
    );
    if (!context.mounted) return;
    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        onSuccess();
      },
    );
    // } catch (e) {
    //   showGlobalSnackBar(e.toString());
    // }
  }
}

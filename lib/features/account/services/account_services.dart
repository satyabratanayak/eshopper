import 'dart:convert';

import 'package:eshopper/constants/error_handling.dart';
import 'package:eshopper/constants/global_variables.dart';
import 'package:eshopper/constants/utils.dart';
import 'package:eshopper/features/auth/screens/auth_screen.dart';
import 'package:eshopper/features/auth/services/auth_service.dart';
import 'package:eshopper/models/order.dart';
import 'package:eshopper/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/orders/me'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      if (!context.mounted) return [];
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showGlobalSnackBar(e.toString());
    }
    return orderList;
  }

  void goToAdmin(BuildContext context) async {
    try {
      logOut(context);
      AuthService authService = AuthService();
      authService.signInUser(
        context: context,
        email: 'test@email.com',
        password: 'test@123',
      );
    } catch (e) {
      showGlobalSnackBar(e.toString());
    }
  }

  void goToBuyer(BuildContext context) async {
    try {
      logOut(context);
      AuthService authService = AuthService();
      authService.signInUser(
        context: context,
        email: 'user@email.com',
        password: 'user@123',
      );
    } catch (e) {
      showGlobalSnackBar(e.toString());
    }
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showGlobalSnackBar(e.toString());
    }
  }
}

import 'dart:convert';

import 'package:eshopper/constants/error_handling.dart';
import 'package:eshopper/constants/global_variables.dart';
import 'package:eshopper/constants/utils.dart';
import 'package:eshopper/models/product.dart';
import 'package:eshopper/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class WishlistServices {
  Future<List<Product>> fetchMyWishlist({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> wishlist = [];

    try {
      final res = await http.get(
        Uri.parse('$uri/api/wishlist'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      if (!context.mounted) return [];

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (var item in jsonDecode(res.body)) {
            wishlist.add(Product.fromJson(jsonEncode(item)));
          }
        },
      );
    } catch (e) {
      showGlobalSnackBar(e.toString());
    }
    return wishlist;
  }

  Future<bool> isProductInWishlist({
    required BuildContext context,
    required String productId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final res = await http.get(
        Uri.parse('$uri/api/wishlist/has/$productId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      if (!context.mounted) return false;

      bool isWishlisted = false;

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final decoded = jsonDecode(res.body);
          if (decoded is Map && decoded['wishlisted'] != null) {
            isWishlisted = decoded['wishlisted'] == true;
          }
        },
      );
      return isWishlisted;
    } catch (e) {
      showGlobalSnackBar(e.toString());
      return false;
    }
  }

  Future<void> addToWishlist({
    required BuildContext context,
    required String productId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final res = await http.post(
        Uri.parse('$uri/api/wishlist'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'productId': productId}),
      );

      if (!context.mounted) return;

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showGlobalSnackBar("Added to wishlist");
        },
      );
    } catch (e) {
      showGlobalSnackBar(e.toString());
    }
  }

  Future<void> removeFromWishlist({
    required BuildContext context,
    required String productId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final res = await http.delete(
        Uri.parse('$uri/api/wishlist/$productId'),
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
          showGlobalSnackBar("Removed from wishlist");
        },
      );
    } catch (e) {
      showGlobalSnackBar(e.toString());
    }
  }
}

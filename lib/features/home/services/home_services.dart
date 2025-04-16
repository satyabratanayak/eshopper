import 'dart:convert';
import 'dart:developer';

import 'package:eshopper/constants/error_handling.dart';
import 'package:eshopper/constants/global_variables.dart';
import 'package:eshopper/constants/utils.dart';
import 'package:eshopper/models/product.dart';
import 'package:eshopper/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeServices {
  Future<List<Product>> fetchAllProducts({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> finalProductList = [];

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/productall/'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      log(userProvider.user.token.toString());

      if (!context.mounted) return [];
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          log('response : ${res.body}');
          final list = jsonDecode(res.body) as List;
          List<Product> productList =
              list.map((e) => Product.fromMap(e)).toList();
          finalProductList = productList;
        },
      );
    } catch (e) {
      showGlobalSnackBar(e.toString());
    }
    return finalProductList;
  }

  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/products?category=$category'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      if (!context.mounted) return [];

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
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
    return productList;
  }

  Future<Product> fetchDealOfDay({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(
      name: '',
      description: '',
      quantity: 0,
      images: [],
      category: '',
      price: 0,
      id: '',
      rating: [],
    );

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/deal-of-day'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      if (!context.mounted) return product;
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          product = Product.fromJson(res.body);
        },
      );
    } catch (e) {
      showGlobalSnackBar(e.toString());
    }
    return product;
  }
}

import 'package:eshopper/common/widgets/user_page.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/features/address/screens/address_screen.dart';
import 'package:eshopper/features/admin/screens/add_product_screen.dart';
import 'package:eshopper/features/auth/screens/auth_screen.dart';
import 'package:eshopper/features/home/screens/category_deals_screen.dart';
import 'package:eshopper/features/home/screens/home_screen.dart';
import 'package:eshopper/features/order_details/screens/all_orders.dart';
import 'package:eshopper/features/order_details/screens/order_details.dart';
import 'package:eshopper/features/product_details/screens/product_details_screen.dart';
import 'package:eshopper/features/search/screens/search_screen.dart';
import 'package:eshopper/features/wishlist/screens/wishlist.dart';
import 'package:eshopper/models/order.dart';
import 'package:eshopper/models/product.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case UserScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const UserScreen(),
      );
    case AddProductScreen.routeName:
      final product = routeSettings.arguments as Product?;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddProductScreen(product: product),
      );

    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryDealsScreen(
          category: category,
        ),
      );
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );
    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      );
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(
          totalAmount: totalAmount,
        ),
      );
    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailScreen(
          order: order,
        ),
      );
    case AllOrdersScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AllOrdersScreen(),
      );
    case Wishlist.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => Wishlist(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text(StringConstants.errorScreenMessage),
          ),
        ),
      );
  }
}

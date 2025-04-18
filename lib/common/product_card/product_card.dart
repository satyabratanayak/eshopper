import 'package:eshopper/common/product_card/horizontal_card.dart';
import 'package:eshopper/common/product_card/vertical_card.dart';
import 'package:eshopper/models/product.dart';
import 'package:flutter/material.dart';

enum UserType {
  admin,
  user,
}

enum CardType {
  vertical,
  horizontal,
}

class ProductCard extends StatelessWidget {
  final UserType userType;
  final CardType cardType;
  final Product product;
  final int? quantity;
  const ProductCard({
    super.key,
    this.userType = UserType.user,
    this.cardType = CardType.vertical,
    required this.product,
    this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return cardType == CardType.horizontal
        ? HorizontalCard(
            product: product,
            quantity: quantity,
          )
        : VerticalCard(product: product);
  }
}

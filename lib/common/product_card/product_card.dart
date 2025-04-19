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
  final bool autoScroll;
  final int? quantity;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  const ProductCard({
    super.key,
    this.userType = UserType.user,
    this.cardType = CardType.vertical,
    required this.product,
    this.quantity,
    this.autoScroll = true,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return cardType == CardType.horizontal
        ? GestureDetector(
            onTap: onTap,
            child: HorizontalCard(
              product: product,
              quantity: quantity,
              userType: userType,
              onDelete: onDelete,
            ),
          )
        : GestureDetector(
            onTap: onTap,
            child: VerticalCard(
              product: product,
              autoScroll: autoScroll,
              userType: userType,
            ),
          );
  }
}

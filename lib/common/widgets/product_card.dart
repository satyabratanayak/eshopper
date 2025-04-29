import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshopper/common/widgets/app_network_image.dart';
import 'package:eshopper/common/widgets/star_ratings.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/constants/utils.dart';
import 'package:eshopper/features/admin/services/admin_services.dart';
import 'package:eshopper/features/cart/services/cart_services.dart';
import 'package:eshopper/features/product_details/services/product_details_services.dart';
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
  final double? totalProducts;
  final int quantity;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    this.userType = UserType.user,
    this.cardType = CardType.vertical,
    required this.product,
    this.quantity = 0,
    this.autoScroll = true,
    this.onDelete,
    this.onTap,
    this.totalProducts,
  });

  @override
  Widget build(BuildContext context) {
    return cardType == CardType.horizontal
        ? GestureDetector(
            onTap: onTap,
            child: _HorizontalCard(
              product: product,
              quantity: quantity,
              userType: userType,
              onDelete: onDelete,
            ),
          )
        : GestureDetector(
            onTap: onTap,
            child: _VerticalCard(
              product: product,
              autoScroll: autoScroll,
              userType: userType,
              totalProducts: totalProducts,
            ),
          );
  }
}

class _HorizontalCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final UserType userType;
  final VoidCallback? onDelete;
  _HorizontalCard({
    required this.product,
    this.quantity = 0,
    required this.userType,
    this.onDelete,
  });

  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();

  final CartServices cartServices = CartServices();

  final AdminServices adminServices = AdminServices();

  @override
  Widget build(BuildContext context) {
    void decreaseQuantity(Product product) {
      cartServices.removeFromCart(
        context: context,
        product: product,
      );
    }

    void increaseQuantity(Product product) {
      productDetailsServices.addToCart(
        context: context,
        product: product,
      );
    }

    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                SizedBox(
                  height: 135,
                  child: AppNetworkImage(
                    imageUrl: product.images[0],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (userType == UserType.user)
                        const Text(
                          StringConstants.limitedTimeDeal,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '-${100 - ((product.price / product.mrp) * 100).ceil()}%',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            product.price > 150
                                ? '₹${product.price}'
                                : '₹${product.price + 50}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(StringConstants.mrp),
                          Text(
                            '₹${product.mrp}',
                            style: const TextStyle(
                              fontSize: 15,
                              decoration: TextDecoration.lineThrough,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      if (userType == UserType.user)
                        product.price > 150
                            ? const Text(
                                StringConstants.eligibleForFreeShipping)
                            : const Text(StringConstants.extraForShipping),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          product.quantity > quantity
                              ? Text(
                                  "${StringConstants.inStock} (${product.quantity.toInt()})",
                                  style: TextStyle(color: Colors.teal),
                                )
                              : const Text(
                                  StringConstants.outOfStock,
                                  style: TextStyle(color: Colors.red),
                                ),
                          Spacer(),
                          if (userType == UserType.admin)
                            GestureDetector(
                              onTap: onDelete,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Colors.transparent,
                                child: Icon(
                                  Icons.delete,
                                  size: 22,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (userType == UserType.user && quantity != 0)
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black12,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => decreaseQuantity(product),
                          child: Container(
                            width: 35,
                            height: 32,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.remove,
                              size: 18,
                            ),
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black12, width: 1.5),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: Container(
                            width: 35,
                            height: 32,
                            alignment: Alignment.center,
                            child: Text(
                              quantity.toString(),
                            ),
                          ),
                        ),
                        product.quantity <= quantity
                            ? InkWell(
                                onTap: () => showGlobalSnackBar(
                                    'Only ${product.quantity.toInt()} item(s) available'),
                                child: Container(
                                  width: 35,
                                  height: 32,
                                  alignment: Alignment.center,
                                  color: Colors.grey.shade300,
                                  child: const Icon(
                                    Icons.add,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () => increaseQuantity(product),
                                child: Container(
                                  width: 35,
                                  height: 32,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.add,
                                    size: 18,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Container(
            color: Colors.black12.withValues(alpha: 0.08),
            height: 1,
          ),
        ],
      ),
    );
  }
}

class _VerticalCard extends StatefulWidget {
  final Product product;
  final bool autoScroll;
  final UserType userType;
  final double? totalProducts;

  const _VerticalCard({
    required this.product,
    required this.autoScroll,
    required this.userType,
    this.totalProducts,
  });

  @override
  State<_VerticalCard> createState() => _VerticalCardState();
}

class _VerticalCardState extends State<_VerticalCard> {
  int _current = 0;
  double avgRating = 0;
  double offerPercent = 0.0;

  @override
  Widget build(BuildContext context) {
    final totalProducts = widget.totalProducts;

    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  CarouselSlider(
                    items: widget.product.images.map(
                      (image) {
                        return AppNetworkImage(imageUrl: image);
                      },
                    ).toList(),
                    options: CarouselOptions(
                      animateToClosest: true,
                      autoPlay: widget.autoScroll,
                      height: double.infinity,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children:
                            widget.product.images.asMap().entries.map((entry) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == entry.key
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  if (totalProducts != null)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          totalProducts.toInt().toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                StarRating(
                  rating: avgRating,
                  reviewCount: widget.product.rating.length,
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${offerPercent.toInt()}% off',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${widget.product.price}',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '₹${widget.product.mrp}',
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    setRating();
    setOfferPercent();
    super.initState();
  }

  void setOfferPercent() {
    setState(() {
      final double price = widget.product.price;
      final double mrp = widget.product.mrp;
      if (price == 0 || mrp == 0) {
        offerPercent = 0.0;
        return;
      }
      offerPercent = ((mrp - price) / mrp * 100).ceilToDouble();
    });
  }

  void setRating() {
    setState(() {
      double totalRating = 0;
      for (int i = 0; i < widget.product.rating.length; i++) {
        totalRating += widget.product.rating[i].rating;
      }

      if (totalRating != 0) {
        avgRating = totalRating / widget.product.rating.length;
      }
    });
  }
}

import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/constants/utils.dart';
import 'package:eshopper/features/cart/services/cart_services.dart';
import 'package:eshopper/features/product_details/services/product_details_services.dart';
import 'package:eshopper/models/product.dart';
import 'package:eshopper/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({
    super.key,
    required this.index,
  });

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  final CartServices cartServices = CartServices();

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    final product = Product.fromMap(productCart['product']);
    final quantity = productCart['quantity'];

    return Column(
      children: [
        const SizedBox(height: 15),
        Container(
          color: Colors.black12.withValues(alpha: 0.08),
          height: 1,
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.network(
                product.images[0],
                fit: BoxFit.cover,
                height: 135,
                width: 135,
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
                    const Text(
                      StringConstants.limitedTimeDeal,
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
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
                    product.price > 150
                        ? const Text(StringConstants.eligibleForFreeShipping)
                        : const Text(StringConstants.extraForShipping),
                    product.quantity >= quantity
                        ? const Text(
                            StringConstants.inStock,
                            style: TextStyle(color: Colors.teal),
                          )
                        : const Text(
                            StringConstants.outOfStock,
                            style: TextStyle(color: Colors.red),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                        border: Border.all(color: Colors.black12, width: 1.5),
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
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
}

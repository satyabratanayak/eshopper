import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshopper/common/widgets/app_network_image.dart';
import 'package:eshopper/common/widgets/custom_button.dart';
import 'package:eshopper/common/widgets/star_ratings.dart';
import 'package:eshopper/constants/global_variables.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/features/product_details/services/product_details_services.dart';
import 'package:eshopper/features/search/screens/search_screen.dart';
import 'package:eshopper/models/product.dart';
import 'package:eshopper/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  double avgRating = 0;
  double myRating = 0;
  int _current = 0;
  double offerPercent = 0.0;

  void addToCart() {
    productDetailsServices.addToCart(
      context: context,
      product: widget.product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(7),
                  elevation: 1,
                  child: TextFormField(
                    onFieldSubmitted: navigateToSearchScreen,
                    decoration: InputDecoration(
                      prefixIcon: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.only(top: 10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide.none,
                      ),
                      hintText: StringConstants.search,
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.product.id),
                  StarRating(
                    rating: avgRating,
                    reviewCount: widget.product.rating.length,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  widget.product.name,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CarouselSlider(
                      items: widget.product.images.map(
                        (i) {
                          return AppNetworkImage(
                            imageUrl: i,
                            fit: BoxFit.cover,
                          );
                        },
                      ).toList(),
                      options: CarouselOptions(
                        viewportFraction: 1,
                        height: double.infinity,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 15,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${offerPercent.toInt()}% off',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      left: MediaQuery.of(context).size.width / 2 - 20,
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
                    Positioned(
                      bottom: 3,
                      right: 20,
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.grey,
                          size: 30,
                        ),
                        onPressed: () {
                          // TODO: Add wishlist service
                          // productDetailsServices.addToWishlist(
                          //   context: context,
                          //   product: widget.product,
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  StringConstants.limitedTimeDeal,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: StringConstants.dealPrice,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '₹${widget.product.price}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: StringConstants.mrp,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '₹${widget.product.mrp}',
                      style: const TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Text(
                StringConstants.productDescription,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(widget.product.description),
              Divider(),
              widget.product.quantity.toInt() == 0
                  ? Text(
                      StringConstants.outOfStock,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    )
                  : Text(
                      '${StringConstants.inStock}: ${widget.product.quantity.toInt()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              const SizedBox(height: 10),
              CustomButton(
                text: StringConstants.buyNow,
                color: GlobalVariables.secondaryColor,
                //TODO: Add buy now functionality
                onTap: () {},
                isEnabled: widget.product.quantity.toInt() != 0,
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: StringConstants.addToCart,
                onTap: addToCart,
                color: GlobalVariables.secondaryColor,
                isEnabled: widget.product.quantity.toInt() != 0,
              ),
              Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  StringConstants.rateProduct,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              RatingBar.builder(
                initialRating: myRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: GlobalVariables.secondaryColor,
                ),
                onRatingUpdate: (rating) {
                  productDetailsServices.rateProduct(
                    context: context,
                    product: widget.product,
                    rating: rating,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    double totalRating = 0;
    for (int i = 0; i < widget.product.rating.length; i++) {
      totalRating += widget.product.rating[i].rating;
      if (widget.product.rating[i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.product.rating[i].rating;
      }
    }

    if (totalRating != 0) {
      avgRating = totalRating / widget.product.rating.length;
    }

    setOfferPercent();
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

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }
}

class Divider extends StatelessWidget {
  const Divider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      color: Colors.black12,
      height: 2,
    );
  }
}

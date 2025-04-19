import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshopper/common/product_card/product_card.dart';
import 'package:eshopper/common/widgets/app_network_image.dart';
import 'package:eshopper/common/widgets/star_ratings.dart';
import 'package:eshopper/models/product.dart';
import 'package:flutter/material.dart';

class VerticalCard extends StatefulWidget {
  final Product product;
  final bool autoScroll;
  final UserType userType;

  const VerticalCard({
    super.key,
    required this.product,
    required this.autoScroll,
    required this.userType,
  });

  @override
  State<VerticalCard> createState() => _VerticalCardState();
}

class _VerticalCardState extends State<VerticalCard> {
  int _current = 0;
  double avgRating = 0;
  double offerPercent = 0.0;

  @override
  Widget build(BuildContext context) {
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

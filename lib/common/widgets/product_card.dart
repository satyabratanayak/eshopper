import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshopper/models/product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class StarRating extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final Color color;

  const StarRating({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.color = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar =
        (rating - fullStars) >= 0.25 && (rating - fullStars) < 0.75;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      children: [
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(width: 2),
        ...List.generate(
            fullStars, (index) => Icon(Icons.star, color: color, size: 16)),
        if (hasHalfStar) Icon(Icons.star_half, color: color, size: 16),
        ...List.generate(emptyStars,
            (index) => Icon(Icons.star_border, color: color, size: 16)),
        const SizedBox(width: 5),
        Text(
          '($reviewCount)',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _ProductCardState extends State<ProductCard> {
  int _current = 0;
  double avgRating = 0;

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
                      (i) {
                        return Builder(
                          builder: (BuildContext context) => Image.network(
                            i,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      },
                    ).toList(),
                    options: CarouselOptions(
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
            padding: const EdgeInsets.all(5),
            child: Text(
              widget.product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18),
            ),
          ),
          StarRating(
            rating: avgRating,
            reviewCount: widget.product.rating.length,
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${100 - ((widget.product.price / widget.product.mrp) * 100).ceil()}% off',
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
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    setRating();
    super.initState();
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

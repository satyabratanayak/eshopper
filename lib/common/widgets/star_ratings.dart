import 'package:flutter/material.dart';

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
        const SizedBox(width: 5),
        ...List.generate(
            fullStars, (index) => Icon(Icons.star, color: color, size: 16)),
        if (hasHalfStar) Icon(Icons.star_half, color: color, size: 16),
        ...List.generate(emptyStars,
            (index) => Icon(Icons.star_border, color: color, size: 16)),
        const SizedBox(width: 10),
        Text(
          '($reviewCount)',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

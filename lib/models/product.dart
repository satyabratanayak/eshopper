import 'dart:convert';

import 'package:eshopper/models/rating.dart';

class Product {
  final String name;
  final String description;
  final double quantity;
  final List<String> images;
  final String category;
  final double price;
  final String id;
  final List<Rating> rating;
  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    required this.id,
    required this.rating,
  });

  factory Product.empty() => Product(
        name: '',
        description: '',
        quantity: 0,
        images: [],
        category: '',
        price: 0,
        id: '',
        rating: [],
      );

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      images: List<String>.from(map['images']),
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      id: map['_id'] ?? '',
      rating: map['ratings'] != null
          ? List<Rating>.from(
              map['ratings']?.map(
                (x) => Rating.fromMap(x),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      'id': id,
      'rating': rating,
    };
  }
}

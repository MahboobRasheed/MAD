import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final double? originalPrice;
  final String description;
  final List<String> images;
  final double rating;
  final int reviews;
  final bool isFavorite;
  final List<String> sizes;
  final List<Color> colors;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.description,
    required this.images,
    this.rating = 0.0,
    this.reviews = 0,
    this.isFavorite = false,
    this.sizes = const [],
    this.colors = const [],
  });

  // Helper method to convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'originalPrice': originalPrice,
      'description': description,
      'images': images,
      'rating': rating,
      'reviews': reviews,
      'isFavorite': isFavorite,
      'sizes': sizes,
      // ignore: deprecated_member_use
      'colors': colors.map((c) => c.value).toList(),
    };
  }

  // Factory method to create Product from Firestore data
  factory Product.fromFirestore(Map<String, dynamic> data) {
    return Product(
      id: data['id'] is int ? data['id'] : int.tryParse(data['id'].toString()) ?? 0,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      originalPrice: data['originalPrice']?.toDouble(),
      description: data['description'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviews: data['reviews'] ?? 0,
      isFavorite: data['isFavorite'] ?? false,
      sizes: List<String>.from(data['sizes'] ?? []),
      colors: data['colors'] != null
          ? (data['colors'] as List).map((c) => Color(c)).toList()
          : [],
    );
  }
}

class CartItem {
  final Product product;
  int quantity;
  String? selectedSize;
  Color? selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  double get totalPrice => product.price * quantity;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem &&
        other.product.id == product.id &&
        other.selectedSize == selectedSize &&
        other.selectedColor == selectedColor;
  }

  @override
  int get hashCode =>
      product.id.hashCode ^
      selectedSize.hashCode ^
      selectedColor.hashCode;

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'selectedSize': selectedSize,
      // ignore: deprecated_member_use
      'selectedColor': selectedColor?.value,
    };
  }
}
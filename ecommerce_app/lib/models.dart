class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double originalPrice;
  final String description;
  final bool isOnSale;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    this.originalPrice = 0,
    this.isOnSale = false,
    this.stock = 10,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});
}
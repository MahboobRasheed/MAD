import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';
import 'models/product.dart';

class CartProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<CartItem> _cartItems = [];
  bool _isLoading = false;
  final double _shippingCost = 5.99;
  final double _taxRate = 0.10;

  List<CartItem> get cartItems => List.from(_cartItems);
  bool get isLoading => _isLoading;
  double get shippingCost => _shippingCost;
  double get taxRate => _taxRate;

  int get itemCount => _cartItems.length;

  double get subtotal {
    return _cartItems.fold(0.0, (total, item) => total + item.totalPrice);
  }

  double get tax => subtotal * _taxRate;
  double get totalAmount => subtotal + shippingCost + tax;

  // Initialize cart
  Future<void> initialize() async {
    await loadCart();
  }

  // Load cart from Firestore
  Future<void> loadCart() async {
    if (!_firebaseService.isLoggedIn) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final cartSnapshot = await _firestore
          .collection('users')
          .doc(_firebaseService.userId)
          .collection('cart')
          .orderBy('updatedAt', descending: true)
          .get();

      _cartItems.clear();

      for (var doc in cartSnapshot.docs) {
        final data = doc.data();

        // Convert productId to int
        final productId = data['productId'] is int
            ? data['productId']
            : int.tryParse(data['productId'].toString()) ?? 0;

        final product = Product(
          id: productId,
          name: data['name'] ?? '',
          category: data['category'] ?? '',
          price: (data['price'] ?? 0.0).toDouble(),
          originalPrice: data['originalPrice']?.toDouble(),
          description: data['description'] ?? '',
          images: List<String>.from(data['images'] ?? []),
          rating: (data['rating'] ?? 0.0).toDouble(),
          reviews: data['reviews'] ?? 0,
          sizes: List<String>.from(data['sizes'] ?? []),
          colors: data['colors'] != null
              ? (data['colors'] as List).map((c) => Color(c)).toList()
              : [],
        );

        final cartItem = CartItem(
          product: product,
          quantity: data['quantity'] ?? 1,
          selectedSize: data['selectedSize'],
          selectedColor: data['selectedColor'] != null
              ? Color(data['selectedColor'])
              : null,
        );

        _cartItems.add(cartItem);
      }

      // Update user's cart count
      if (_firebaseService.isLoggedIn) {
        await _firestore.collection('users').doc(_firebaseService.userId).update({
          'cartCount': _cartItems.length,
          'updatedAt': DateTime.now(),
        });
      }
    } catch (e) {
      // print('Load cart error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add to cart - FIXED
  Future<void> addToCart({
    required Product product,
    int quantity = 1,
    String? size,
    Color? color,
  }) async {
    // print('🛒 ADDING TO CART: ${product.name}, Qty: $quantity');

    try {
      // For guest users (not logged in)
      if (!_firebaseService.isLoggedIn) {
        // print('👤 Guest user - Adding to local cart');

        final existingIndex = _cartItems.indexWhere((item) =>
        item.product.id == product.id &&
            item.selectedSize == size &&
            item.selectedColor == color);

        if (existingIndex != -1) {
          _cartItems[existingIndex].quantity += quantity;
          // print('📈 Updated existing item quantity');
        } else {
          _cartItems.add(CartItem(
            product: product,
            quantity: quantity,
            selectedSize: size,
            selectedColor: color,
          ));
          // print('➕ Added new item to cart');
        }
        notifyListeners();

        // Debug print
        // print('🛍️ Cart now has ${_cartItems.length} items');
        // for (var item in _cartItems) {
        //   // print('   - ${item.product.name} x${item.quantity}');
        // }

        return;
      }

      // For logged in users - sync with Firestore
      // print('👤 Logged in user - Syncing with Firestore');

      // ignore: deprecated_member_use
      final docId = '${product.id}_${size ?? 'nosize'}_${color?.value ?? 'nocolor'}';
      final cartRef = _firestore
          .collection('users')
          .doc(_firebaseService.userId)
          .collection('cart')
          .doc(docId);

      final cartDoc = await cartRef.get();

      if (cartDoc.exists) {
        // Update quantity
        final currentQty = cartDoc.data()?['quantity'] ?? 0;
        await cartRef.update({
          'quantity': currentQty + quantity,
          'updatedAt': DateTime.now(),
        });
        // print('📈 Updated quantity in Firestore');
      } else {
        // Add new item
        await cartRef.set({
          'productId': product.id,
          'name': product.name,
          'category': product.category,
          'price': product.price,
          'originalPrice': product.originalPrice,
          'description': product.description,
          'images': product.images,
          'rating': product.rating,
          'reviews': product.reviews,
          'sizes': product.sizes,
          // ignore: deprecated_member_use
          'colors': product.colors.map((c) => c.value).toList(),
          'quantity': quantity,
          'selectedSize': size,
          // ignore: deprecated_member_use
          'selectedColor': color?.value,
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
        });
        // print('➕ Added new item to Firestore');
      }

      // Reload cart
      await loadCart();

    } catch (e) {
      // print('❌ Add to cart error: $e');
      // Show error to user
      rethrow;
    }
  }

  // Update quantity
  Future<void> updateQuantity(int productId, int quantity,
      {String? size, Color? color}) async {
    try {
      if (!_firebaseService.isLoggedIn) {
        final index = _cartItems.indexWhere((item) =>
        item.product.id == productId &&
            item.selectedSize == size &&
            item.selectedColor == color);

        if (index != -1 && quantity > 0) {
          _cartItems[index].quantity = quantity;
          notifyListeners();
        }
        return;
      }

      if (quantity <= 0) {
        await removeFromCart(productId, size: size, color: color);
        return;
      }

      await _firestore
          .collection('users')
          .doc(_firebaseService.userId)
          .collection('cart')
          // ignore: deprecated_member_use
          .doc('${productId}_${size ?? 'nosize'}_${color?.value ?? 'nocolor'}')
          .update({
        'quantity': quantity,
        'updatedAt': DateTime.now(),
      });

      await loadCart();
    } catch (e) {
      // print('Update quantity error: $e');
    }
  }

  // Remove from cart
  Future<void> removeFromCart(int productId,
      {String? size, Color? color}) async {
    try {
      if (!_firebaseService.isLoggedIn) {
        _cartItems.removeWhere((item) =>
        item.product.id == productId &&
            item.selectedSize == size &&
            item.selectedColor == color);
        notifyListeners();
        return;
      }

      await _firestore
          .collection('users')
          .doc(_firebaseService.userId)
          .collection('cart')
          // ignore: deprecated_member_use
          .doc('${productId}_${size ?? 'nosize'}_${color?.value ?? 'nocolor'}')
          .delete();

      await loadCart();
    } catch (e) {
      // print('Remove from cart error: $e');
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      if (!_firebaseService.isLoggedIn) {
        _cartItems.clear();
        notifyListeners();
        return;
      }

      final cartSnapshot = await _firestore
          .collection('users')
          .doc(_firebaseService.userId)
          .collection('cart')
          .get();

      for (var doc in cartSnapshot.docs) {
        await doc.reference.delete();
      }
      //
      await loadCart();
    } catch (e) {
      // print('Clear cart error: $e');
    }
  }

  // Place Order
  Future<void> placeOrder() async {
    if (!_firebaseService.isLoggedIn) return;

    try {
      final orderData = {
        'userId': _firebaseService.userId,
        'items': _cartItems.map((item) => {
          'productId': item.product.id,
          'name': item.product.name,
          'price': item.product.price,
          'quantity': item.quantity,
          'selectedSize': item.selectedSize,
          // ignore: deprecated_member_use
          'selectedColor': item.selectedColor?.value,
          'image': item.product.images.isNotEmpty ? item.product.images.first : null,
        }).toList(),
        'subtotal': subtotal,
        'shippingCost': shippingCost,
        'tax': tax,
        'totalAmount': totalAmount,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Add to user's orders collection
      await _firestore
          .collection('users')
          .doc(_firebaseService.userId)
          .collection('orders')
          .add(orderData);

      // Update user stats
      await _firestore.collection('users').doc(_firebaseService.userId).update({
        'orderCount': FieldValue.increment(1),
        'totalSpent': FieldValue.increment(totalAmount),
      });

      // Clear cart
      await clearCart();
    } catch (e) {
      // print('Place order error: $e');
      rethrow;
    }
  }

  // Check if item is in cart
  bool isInCart(Product product, {String? size, Color? color}) {
    return _cartItems.any((item) =>
    item.product.id == product.id &&
        item.selectedSize == size &&
        item.selectedColor == color);
  }

  // Get item quantity
  int getItemQuantity(Product product, {String? size, Color? color}) {
    final item = _cartItems.firstWhere(
          (item) =>
      item.product.id == product.id &&
          item.selectedSize == size &&
          item.selectedColor == color,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    return item.quantity;
  }
}
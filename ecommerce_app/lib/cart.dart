import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'models/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Load cart when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.blue[800],
        actions: [
          if (cartProvider.cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _clearCart(cartProvider),
              tooltip: 'Clear Cart',
            ),
        ],
      ),
      body: cartProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartProvider.cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
        children: [
          // Cart Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartProvider.cartItems[index];
                return _buildCartItem(cartItem, index, cartProvider);
              },
            ),
          ),

          // Checkout Section
          _buildCheckoutSection(cartProvider),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Add items to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem cartItem, int index, CartProvider cartProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                image: cartItem.product.images.isNotEmpty
                    ? DecorationImage(
                  image: AssetImage(cartItem.product.images[0]),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: cartItem.product.images.isEmpty
                  ? Icon(
                _getCategoryIcon(cartItem.product.category),
                color: Colors.grey[400],
                size: 40,
              )
                  : null,
            ),

            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          cartItem.product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        color: Colors.grey,
                        onPressed: () {
                          _removeItem(index, cartProvider);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Category
                  Text(
                    cartItem.product.category,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Size and Color
                  if (cartItem.selectedSize != null || cartItem.selectedColor != null)
                    Row(
                      children: [
                        if (cartItem.selectedSize != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.blue[100]!),
                            ),
                            child: Text(
                              'Size: ${cartItem.selectedSize}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),

                        if (cartItem.selectedColor != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Color: ',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Container(
                                  width: 12,
                                  height: 12,
                                  margin: const EdgeInsets.only(left: 4),
                                  decoration: BoxDecoration(
                                    color: cartItem.selectedColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                  const SizedBox(height: 12),

                  // Price and Quantity Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Text(
                        '\$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      // Quantity Controls
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            // Decrease Button
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () {
                                if (cartItem.quantity > 1) {
                                  cartProvider.updateQuantity(
                                    cartItem.product.id,
                                    cartItem.quantity - 1,
                                    size: cartItem.selectedSize,
                                    color: cartItem.selectedColor,
                                  );
                                } else {
                                  _removeItem(index, cartProvider);
                                }
                              },
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                            ),

                            // Quantity Display
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '${cartItem.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),

                            // Increase Button
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () {
                                cartProvider.updateQuantity(
                                  cartItem.product.id,
                                  cartItem.quantity + 1,
                                  size: cartItem.selectedSize,
                                  color: cartItem.selectedColor,
                                );
                              },
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                            ),
                          ],
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
    );
  }

  Widget _buildCheckoutSection(CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Order Summary Title
          const Row(
            children: [
              Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Subtotal
          _buildSummaryRow(
            label: 'Subtotal',
            value: '\$${cartProvider.subtotal.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 8),

          // Shipping
          _buildSummaryRow(
            label: 'Shipping',
            value: '\$${cartProvider.shippingCost.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 8),

          // Tax
          _buildSummaryRow(
            label: 'Tax (10%)',
            value: '\$${cartProvider.tax.toStringAsFixed(2)}',
          ),

          const Divider(height: 24, thickness: 1),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => _checkout(context, cartProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Continue Shopping Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue[800]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Continue Shopping',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Shoes':
        return Icons.sports_basketball;
      case 'Clothes':
        return Icons.checkroom;
      case 'Suits':
        return Icons.people;
      case 'Jewelry':
        return Icons.diamond;
      default:
        return Icons.shopping_bag;
    }
  }

  void _removeItem(int index, CartProvider cartProvider) {
    final cartItem = cartProvider.cartItems[index];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: Text('Remove "${cartItem.product.name}" from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cartProvider.removeFromCart(
                cartItem.product.id,
                size: cartItem.selectedSize,
                color: cartItem.selectedColor,
              );
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed ${cartItem.product.name} from cart'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _clearCart(CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to clear your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cartProvider.clearCart();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cart cleared successfully'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _checkout(BuildContext context, CartProvider cartProvider) {
    if (cartProvider.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Summary:'),
            const SizedBox(height: 10),
            Text('Items: ${cartProvider.itemCount}'),
            Text('Subtotal: \$${cartProvider.subtotal.toStringAsFixed(2)}'),
            Text('Shipping: \$${cartProvider.shippingCost.toStringAsFixed(2)}'),
            Text('Tax: \$${cartProvider.tax.toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            Text(
              'Total: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Proceed with checkout?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // Process checkout
                await cartProvider.placeOrder();

                if (!context.mounted) return;
                Navigator.pop(context);

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order placed successfully!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ),
                );

                // Navigate to home
                Navigator.pop(context);
              } catch (e) {
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order failed: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );
  }
}
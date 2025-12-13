import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';
import 'cart.dart';
import 'cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  String? _selectedSize;
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    // Set default selections
    if (widget.product.sizes.isNotEmpty) {
      _selectedSize = widget.product.sizes.first;
    }
    if (widget.product.colors.isNotEmpty) {
      _selectedColor = widget.product.colors.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    //   Get CartProvider from context using Provider
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.blue[800],
        actions: [
          // Cart icon with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartProvider.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images
            _buildProductImages(),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),

                  // Original Price if available
                  if (widget.product.originalPrice != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        '\$${widget.product.originalPrice!.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[500],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),

                  // Rating
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        '${widget.product.rating}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '(${widget.product.reviews} reviews)',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Category
                  Text(
                    'Category: ${widget.product.category}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),

                  // Size Selection
                  if (widget.product.sizes.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Select Size',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: widget.product.sizes.map((size) {
                        bool isSelected = _selectedSize == size;
                        return ChoiceChip(
                          label: Text(size),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedSize = selected ? size : null;
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: Colors.blue[800],
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  // Color Selection
                  if (widget.product.colors.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Select Color',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: widget.product.colors.map((color) {
                        bool isSelected = _selectedColor == color;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: Colors.blue, width: 3)
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  // Quantity Selector
                  const SizedBox(height: 20),
                  const Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() {
                              _quantity--;
                            });
                          }
                        },
                      ),
                      Container(
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                      ),
                      const Spacer(),
                      Text(
                        'Total: \$${(widget.product.price * _quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Add to Cart Button - UPDATED
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _addToCart(cartProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImages() {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[200],
            child: Image.asset(
              widget.product.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                widget.product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: widget.product.isFavorite ? Colors.red : Colors.grey,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  FIXED: Added cartProvider as parameter
  void _addToCart(CartProvider cartProvider) {
    // print ADD TO CART BUTTON CLICKED

    cartProvider.addToCart(
      product: widget.product,
      quantity: _quantity,
      size: _selectedSize,
      color: _selectedColor,
    ).then((_) {
      if (!mounted) return;
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ ${widget.product.name} added to cart (x$_quantity)'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'View Cart',
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ),
      );

      // Update UI
      setState(() {});
    }).catchError((error) {
      if (!mounted) return;
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to add to cart: $error'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
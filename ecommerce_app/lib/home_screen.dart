import 'package:flutter/material.dart';
import 'product_detail.dart';
import 'cart.dart';
import 'profile.dart';
import 'models/product.dart';
import 'data/products_data.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['All', 'Popular'];
  int _selectedTab = 0;
  String _selectedCategory = 'All';
  final List<String> categories = ProductsData.getCategories();

  // Filtered products based on category and tab
  List<Product> get _filteredProducts {
    List<Product> products = [];

    // First filter by tab
    switch (_tabs[_selectedTab]) {
      case 'Popular':
        products = ProductsData.getPopularProducts();
        break;
      default: // 'All' tab
        products = ProductsData.allProducts;
        break;
    }

    // Then filter by category if not 'All'
    if (_selectedCategory != 'All') {
      products = products.where((p) => p.category == _selectedCategory).toList();
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Retail Shop'),
        backgroundColor: Colors.blue[800],
        actions: [
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
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    if (cartProvider.itemCount > 0) {
                      return Container(
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
                      );
                    }
                    return const SizedBox();
                  },
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
            // Special Offer Banner
            _buildSpecialOfferBanner(),

            const SizedBox(height: 20),

            // Categories Section
            _buildCategoriesSection(),

            const SizedBox(height: 25),

            // Flash Sale Section
            _buildFlashSaleSection(),

            const SizedBox(height: 30),

            // Products Section with Count
            _buildProductsSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue[800],
      ),
    );
  }

  Widget _buildSpecialOfferBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SpecialForYou',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Get Special Offer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                'Up to 40',
                style: TextStyle(
                  color: Colors.amber[300],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                '%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categorize',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // View all categories
                },
                child: Row(
                  children: [
                    Text(
                      'Business',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(Icons.arrow_forward, color: Colors.grey[600], size: 18),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Categories Scroll
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((category) {
                Color color;
                IconData icon;

                switch (category) {
                  case 'Shoes':
                    color = Colors.orange;
                    icon = Icons.sports_basketball;
                    break;
                  case 'Clothes':
                    color = Colors.green;
                    icon = Icons.checkroom;
                    break;
                  case 'Suits':
                    color = Colors.purple;
                    icon = Icons.people;
                    break;
                  case 'Jewelry':
                    color = Colors.amber;
                    icon = Icons.diamond;
                    break;
                  default: // 'All'
                    color = Colors.blue;
                    icon = Icons.all_inclusive;
                }

                return _buildCategoryItem(category, icon, color);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, Color color) {
    bool isSelected = _selectedCategory == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = title;
        });
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: isSelected ? color : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? color : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlashSaleSection() {
    final flashSaleProducts = ProductsData.getFlashSaleProducts();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Flash Sale',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.red, size: 16),
                    const SizedBox(width: 6),
                    const Text(
                      'Closing in : ',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '02 : 12 : 56',
                      style: TextStyle(
                        color: Colors.red[900],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Flash Sale Products
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: flashSaleProducts.length,
              itemBuilder: (context, index) {
                final product = flashSaleProducts[index];
                return _buildFlashSaleItem(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashSaleItem(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  color: Colors.grey[200],
                  image: DecorationImage(
                    image: AssetImage(product.images[0]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (product.originalPrice != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '\$${product.originalPrice!.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
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

  Widget _buildProductsSection() {
    final filteredProducts = _filteredProducts;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab Bar with product count
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: List.generate(_tabs.length, (index) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTab = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedTab == index ? Colors.blue[800] : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                _tabs[index],
                                style: TextStyle(
                                  color: _selectedTab == index ? Colors.white : Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${filteredProducts.length} items',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Products Grid
          if (filteredProducts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'No products found',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Try changing category or filter',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return _buildProductItem(product);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  color: Colors.grey[200],
                  image: DecorationImage(
                    image: AssetImage(product.images[0]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(
                          product.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: product.isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          // Toggle favorite
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category,
                    style: TextStyle(
                      color: _getCategoryColor(product.category),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart, size: 20),
                        color: Colors.blue[800],
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
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
// IconData _getCategoryIcon(String category) {
  //   switch (category) {
  //     case 'Shoes':
  //       return Icons.sports_basketball;
  //     case 'Clothes':
  //       return Icons.checkroom;
  //     case 'Suits':
  //       return Icons.people;
  //     case 'Jewelry':
  //       return Icons.diamond;
  //     default:
  //       return Icons.shopping_bag;
  //   }
  // }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Shoes':
        return Colors.orange;
      case 'Clothes':
        return Colors.green;
      case 'Suits':
        return Colors.purple;
      case 'Jewelry':
        return Colors.amber;
      default:
        return Colors.blue;
    }
  }
}
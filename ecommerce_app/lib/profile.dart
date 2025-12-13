import 'package:ecommerce_app/login.dart';
import 'package:ecommerce_app/firebase_service.dart';
import 'package:ecommerce_app/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    if (firebaseService.isLoggedIn) {
      final data = await firebaseService.getUserData(firebaseService.userId!);
      setState(() {
        _userData = data;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditProfileDialog();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue[100],
                  backgroundImage: _userData?['photoUrl'] != null
                      ? NetworkImage(_userData!['photoUrl'])
                      : null,
                  child: _userData?['photoUrl'] == null
                      ? const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.blue,
                  )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // User Name
            Text(
              _userData?['name'] ?? 'User',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // User Email
            Text(
              _userData?['email'] ?? 'No email',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 20),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  title: 'Cart Items',
                  value: (_userData?['cartCount'] ?? 0).toString(),
                  icon: Icons.shopping_cart,
                ),
                _buildStatItem(
                  title: 'Orders',
                  value: (_userData?['orderCount'] ?? 0).toString(),
                  icon: Icons.shopping_bag,
                ),
                _buildStatItem(
                  title: 'Spent',
                  value: '\$${(_userData?['totalSpent'] ?? 0.0).toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Profile Sections
            _buildProfileSection(firebaseService),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({required String title, required String value, required IconData icon}) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 30),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(FirebaseService firebaseService) {
    return Column(
      children: [
        _buildProfileItem(
          icon: Icons.person_outline,
          title: 'Personal Information',
          onTap: _showEditProfileDialog,
        ),

        _buildProfileItem(
          icon: Icons.location_on_outlined,
          title: 'Shipping Address',
          onTap: () {
            _showAddressDialog();
          },
        ),

        _buildProfileItem(
          icon: Icons.phone_outlined,
          title: 'Phone Number',
          onTap: () {
            _showPhoneDialog();
          },
        ),

        _buildProfileItem(
          icon: Icons.lock_outline,
          title: 'Change Password',
          onTap: _showChangePasswordDialog,
        ),

        _buildProfileItem(
          icon: Icons.shopping_bag_outlined,
          title: 'My Orders',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrdersScreen()),
            );
          },
        ),

        _buildProfileItem(
          icon: Icons.favorite_border,
          title: 'Wishlist',
          onTap: () {
            // Navigate to wishlist screen
          },
        ),

        _buildProfileItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () {
            // Navigate to help screen
          },
        ),

        const SizedBox(height: 30),

        // Logout Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _showLogoutDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[800]),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showEditProfileDialog() {
    final TextEditingController nameController = TextEditingController(
      text: _userData?['name'] ?? '',
    );
    final TextEditingController emailController = TextEditingController(
      text: _userData?['email'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              final firebaseService = Provider.of<FirebaseService>(context, listen: false);
              await firebaseService.updateUserProfile(
                firebaseService.userId!,
                {
                  'name': nameController.text,
                  'email': emailController.text,
                },
              );
              await _loadUserData();
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('Profile updated successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddressDialog() {
    final TextEditingController addressController = TextEditingController(
      text: _userData?['address'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Shipping Address'),
        content: TextField(
          controller: addressController,
          decoration: const InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
            hintText: 'Enter your full address',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              final firebaseService = Provider.of<FirebaseService>(context, listen: false);
              await firebaseService.updateUserProfile(
                firebaseService.userId!,
                {'address': addressController.text},
              );
              await _loadUserData();
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('Address updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPhoneDialog() {
    final TextEditingController phoneController = TextEditingController(
      text: _userData?['phone'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Phone Number'),
        content: TextField(
          controller: phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone',
            border: OutlineInputBorder(),
            hintText: 'Enter your phone number',
          ),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              final firebaseService = Provider.of<FirebaseService>(context, listen: false);
              await firebaseService.updateUserProfile(
                firebaseService.userId!,
                {'phone': phoneController.text},
              );
              await _loadUserData();
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('Phone number updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }

              if (newPasswordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password must be at least 6 characters')),
                );
                return;
              }

              // Here you would implement password change logic
              // For security reasons, you need to re-authenticate first
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password change feature coming soon')),
              );
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              Navigator.pop(context);
              final firebaseService = Provider.of<FirebaseService>(context, listen: false);
              await firebaseService.logout();
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
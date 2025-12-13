import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_service.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.blue[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseService.userId)
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final order = snapshot.data!.docs[index];
              final data = order.data() as Map<String, dynamic>;
              final date = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
              final items = (data['items'] as List<dynamic>?) ?? [];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ExpansionTile(
                  title: Text(
                    'Order #${order.id.substring(0, 8).toUpperCase()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${DateFormat('MMM d, yyyy').format(date)} • \$${(data['totalAmount'] ?? 0).toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...items.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item['quantity']}x ${item['name']}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text('\$${(item['price'] ?? 0).toStringAsFixed(2)}'),
                              ],
                            ),
                          )),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                '\$${(data['totalAmount'] ?? 0).toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              (data['status'] ?? 'Pending').toString().toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Travel image from the internet
          Image.network(
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200',
            fit: BoxFit.cover,
          ),

          const SizedBox(height: 16),

          // Welcome message inside a Container
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal.shade50,
            child: const Text(
              'Welcome to the Travel Guide App! Your companion for discovering new destinations.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),

          const SizedBox(height: 16),

          // Slogan using RichText
          RichText(
            text: const TextSpan(
              text: 'Explore ',
              style: TextStyle(fontSize: 20, color: Colors.black),
              children: [
                TextSpan(
                    text: 'the World ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal)),
                TextSpan(text: 'with Us! 🌍'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // TextField for destination
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Enter Destination',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Two Buttons
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search started!')),
              );
            },
            child: const Text('Search Destination'),
          ),
          TextButton(
            onPressed: () {
              print('TextButton pressed!');
            },
            child: const Text('Click Me'),
          ),
        ],
      ),
    );
  }
}

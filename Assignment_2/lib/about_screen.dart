// about_screen.dart
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  final List<Map<String, String>> attractions = const [
    {
      'name': 'Eiffel Tower',
      'image': 'https://upload.wikimedia.org/wikipedia/commons/a/a8/Tour_Eiffel_Wikimedia_Commons.jpg'
    },
    {
      'name': 'Great Wall of China',
      'image': 'https://upload.wikimedia.org/wikipedia/commons/6/6f/Mutianyu_Great_Wall_2019.jpg'
    },
    {
      'name': 'Taj Mahal',
      'image': 'https://upload.wikimedia.org/wikipedia/commons/d/da/Taj-Mahal.jpg'
    },
    {
      'name': 'Sydney Opera House',
      'image': 'https://upload.wikimedia.org/wikipedia/commons/4/40/Sydney_Opera_House_Sails.jpg'
    },
    {
      'name': 'Statue of Liberty',
      'image': 'https://upload.wikimedia.org/wikipedia/commons/a/a1/Statue_of_Liberty_7.jpg'
    },
    {
      'name': 'Machu Picchu',
      'image': 'https://upload.wikimedia.org/wikipedia/commons/e/eb/Machu_Picchu%2C_Peru.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.all(10),
      children: attractions.map((place) {
        return Column(
          children: [
            Expanded(
              child: Image.network(place['image']!, fit: BoxFit.cover),
            ),
            const SizedBox(height: 5),
            Text(
              place['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      }).toList(),
    );
  }
}

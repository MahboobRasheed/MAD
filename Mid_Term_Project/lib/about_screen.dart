import 'package:flutter/material.dart';

/// About screen: GridView of Pakistan landmarks with local images
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const List<Map<String, String>> attractions = [
    {'name': 'Faisal Mosque', 'image': 'assets/images/faisal_mosque.jpg'},
    {'name': 'Badshahi Mosque', 'image': 'assets/images/badshahi_mosque.jpg'},
    {'name': 'Hunza Valley', 'image': 'assets/images/hunza_valley.jpg'},
    {'name': 'Minar-e-Pakistan', 'image': 'assets/images/minar_e_pakistan.jpg'},
    {'name': 'Skardu Lake', 'image': 'assets/images/skardu_lake.jpg'},
    {'name': 'Gwadar Beach', 'image': 'assets/images/gwadar_beach.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(10),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: attractions.map((place) {
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.asset(
                    place['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Text(
                  place['name']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';

/// List screen:
/// - Scrollable ListView of 10+ Pakistani destinations (name + short description)
/// - Each item is a Card with ListTile
class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  static const List<Map<String, String>> _places = [
    {'city': 'Hunza Valley', 'desc': 'Breathtaking mountain valley in Gilgit-Baltistan.'},
    {'city': 'Skardu', 'desc': 'Gateway to high peaks and lovely lakes.'},
    {'city': 'Murree', 'desc': 'Popular hill station near Islamabad.'},
    {'city': 'Fairy Meadows', 'desc': 'Scenic meadows at the foot of Nanga Parbat.'},
    {'city': 'Naran & Kaghan', 'desc': 'Turquoise lakes and alpine scenery.'},
    {'city': 'Swat', 'desc': 'Green valleys and pleasant weather.'},
    {'city': 'Gwadar', 'desc': 'Beautiful beaches along the Arabian Sea.'},
    {'city': 'Lahore', 'desc': 'Historical city with Mughal architecture.'},
    {'city': 'Islamabad', 'desc': 'Modern capital framed by Margalla Hills.'},
    {'city': 'Karachi', 'desc': 'Coastal metropolis with lively culture.'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _places.length,
      itemBuilder: (context, index) {
        final p = _places[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          elevation: 3,
          child: ListTile(
            leading: const Icon(Icons.place, color: Colors.teal),
            title: Text(p['city']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(p['desc']!),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected: ${p['city']}')),
              );
            },
          ),
        );
      },
    );
  }
}

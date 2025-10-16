// list_screen.dart
import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  final List<Map<String, String>> destinations = const [
    {'city': 'Paris', 'desc': 'City of Lights and Love.'},
    {'city': 'Tokyo', 'desc': 'Blend of tradition and technology.'},
    {'city': 'New York', 'desc': 'The city that never sleeps.'},
    {'city': 'Rome', 'desc': 'Home of ancient wonders.'},
    {'city': 'Sydney', 'desc': 'Famous for its Opera House.'},
    {'city': 'Cairo', 'desc': 'Gateway to the pyramids.'},
    {'city': 'London', 'desc': 'Cultural capital of the world.'},
    {'city': 'Dubai', 'desc': 'Land of luxury and innovation.'},
    {'city': 'Istanbul', 'desc': 'Where East meets West.'},
    {'city': 'Bali', 'desc': 'Island of the Gods.'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: const Icon(Icons.location_on, color: Colors.teal),
            title: Text(destinations[index]['city']!),
            subtitle: Text(destinations[index]['desc']!),
          ),
        );
      },
    );
  }
}

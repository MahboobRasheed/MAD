import 'dart:convert';

class Activity {
  final String id;
  final double latitude;
  final double longitude;
  final String? imagePath; // local file path or remote URL
  final DateTime timestamp;

  Activity({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.imagePath,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'imagePath': imagePath,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'].toString(),
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        imagePath: json['imagePath'],
        timestamp: DateTime.parse(json['timestamp']),
      );

  String encode() => jsonEncode(toJson());
}

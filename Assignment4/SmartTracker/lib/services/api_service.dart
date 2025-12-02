import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<Activity>> fetchActivities() async {
    final res = await http.get(Uri.parse('$baseUrl/activities'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Activity.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch activities');
  }

  Future<Activity> createActivity(Activity activity) async {
    final res = await http.post(Uri.parse('$baseUrl/activities'),
        headers: {'Content-Type': 'application/json'}, body: activity.encode());
    if (res.statusCode == 201) {
      return Activity.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed to create activity');
  }

  Future<void> deleteActivity(String id) async {
    final res = await http.delete(Uri.parse('$baseUrl/activities/$id'));
    if (res.statusCode != 200) throw Exception('Failed to delete');
  }
}

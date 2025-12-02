import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/activity.dart';
import '../repositories/activity_repository.dart';

class ActivityProvider extends ChangeNotifier {
  final ActivityRepository repository;
  List<Activity> _activities = [];
  bool loading = false;

  ActivityProvider({required this.repository});

  List<Activity> get activities => _activities;

  Future<void> loadActivities() async {
    loading = true;
    notifyListeners();
    try {
      _activities = await repository.fetchFromApi();
    } catch (e) {
      // fallback to cache
      _activities = repository.getCached();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> addActivity(double lat, double lng, String? imagePath) async {
    final act = Activity(
        id: Uuid().v4(), latitude: lat, longitude: lng, imagePath: imagePath, timestamp: DateTime.now());
    loading = true;
    notifyListeners();
    try {
      await repository.create(act);
      _activities.insert(0, act);
    } catch (e) {
      // if API fails, still cache locally
    }
    loading = false;
    notifyListeners();
  }

  Future<void> deleteActivity(String id) async {
    loading = true;
    notifyListeners();
    try {
      await repository.delete(id);
      _activities.removeWhere((a) => a.id == id);
    } catch (e) {}
    loading = false;
    notifyListeners();
  }
}

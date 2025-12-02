import 'package:hive/hive.dart';
import '../models/activity.dart';
import '../services/api_service.dart';

class ActivityRepository {
  final ApiService apiService;
  final Box box;

  ActivityRepository({required this.apiService, required this.box});

  Future<List<Activity>> fetchFromApi() async {
    return await apiService.fetchActivities();
  }

  Future<Activity> create(Activity activity) async {
    final created = await apiService.createActivity(activity);
    await _cacheRecent(created);
    return created;
  }

  Future<void> delete(String id) async {
    await apiService.deleteActivity(id);
    // remove from cache if present
    final keys = box.keys.cast<String>().toList();
    for (var key in keys) {
      if ((box.get(key) as Map)['id'] == id) {
        await box.delete(key);
      }
    }
  }

  Future<void> _cacheRecent(Activity a) async {
    // store up to 5 recent activities
    final List stored = box.values.cast<Map>().toList();
    // push new
    await box.put(a.id, a.toJson());
    // trim
    final keys = box.keys.cast<String>().toList();
    if (keys.length > 5) {
      // remove oldest by timestamp
      keys.sort((k1, k2) {
        final t1 = DateTime.parse((box.get(k1) as Map)['timestamp']);
        final t2 = DateTime.parse((box.get(k2) as Map)['timestamp']);
        return t1.compareTo(t2);
      });
      while (box.length > 5) {
        await box.delete(keys.removeAt(0));
      }
    }
  }

  List<Activity> getCached() {
    return box.values
        .map((e) => Activity.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList()
        .reversed
        .toList();
  }
}

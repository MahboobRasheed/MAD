import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/activity_provider.dart';
import 'repositories/activity_repository.dart';
import 'services/api_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox('activities');

  final api = ApiService(baseUrl: 'http://10.0.2.2:3000');
  final repo = ActivityRepository(apiService: api, box: box);

  runApp(MyApp(repository: repo));
}

class MyApp extends StatelessWidget {
  final ActivityRepository repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ActivityProvider(repository: repository),
      child: MaterialApp(
        title: 'SmartTracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
      ),
    );
  }
}

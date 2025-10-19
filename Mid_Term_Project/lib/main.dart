import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'list_screen.dart';
import 'about_screen.dart';

void main() {
  runApp(const TripExplorerApp());
}

class TripExplorerApp extends StatefulWidget {
  const TripExplorerApp({super.key});

  @override
  State<TripExplorerApp> createState() => _TripExplorerAppState();
}

class _TripExplorerAppState extends State<TripExplorerApp> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    ListScreen(),
    AboutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Explorer App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Trip Explorer'),
          centerTitle: true,
        ),
        body: SafeArea(child: _screens[_selectedIndex]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          ],
        ),
      ),
    );
  }
}

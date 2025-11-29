import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final doSignOut = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Sign out'),
                  content: Text('Do you want to sign out?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Sign out')),
                  ],
                ),
              );
              if (doSignOut == true) {
                await _auth.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              }
            },
          )
        ],
      ),
      body: Center(child: Text('Welcome, ${_auth.currentUser?.email ?? 'Guest'}')),
    );
  }
}

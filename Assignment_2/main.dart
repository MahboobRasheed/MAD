import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bidding Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:  Scaffold(
        appBar: AppBar(
          title: Text('Bidding Page'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: MaximumBid(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MaximumBid extends StatefulWidget {
  const MaximumBid({super.key});

  @override
  _MaximumBidState createState() => _MaximumBidState();
}

class _MaximumBidState extends State<MaximumBid> {
  int _currentBid = 0;

  void _increaseBid() {
    setState(() {
      _currentBid += 50; // Increase by $50 each tap
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Current Maximum Bid:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Text(
            '\$$_currentBid',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _increaseBid,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('Increase Bid'),
          ),
        ],
      ),
    );
  }
}

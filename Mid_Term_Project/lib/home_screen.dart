import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _destinationController = TextEditingController();

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _showFirstSlogan = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.15)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _showSnackBar() {
    final text = _destinationController.text.trim().isEmpty
        ? 'Searching trips in Pakistan...'
        : 'Searching trips for "${_destinationController.text.trim()}"...';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Hero Image
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              'assets/images/faisal_mosque.jpg',
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image, size: 80, color: Colors.grey)),
            ),
          ),

          const SizedBox(height: 14),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Welcome to Trip Explorer — discover Pakistan’s amazing destinations!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),

          const SizedBox(height: 12),

          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 20, color: Colors.black),
              children: [
                TextSpan(text: 'Explore the '),
                TextSpan(
                    text: 'Beauty of Pakistan',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                TextSpan(text: ' with us!'),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: TextField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: 'Enter destination name',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _showSnackBar, child: const Text('Find Trips')),
                TextButton(
                  onPressed: () {
                    debugPrint('Destination entered: ${_destinationController.text}');
                    setState(() => _showFirstSlogan = !_showFirstSlogan);
                  },
                  child: const Text('Log to Console'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          AnimatedCrossFade(
            firstChild: const Text(
              'Plan your perfect trip with TripExplorerApp!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            secondChild: const Text(
              'Explore mountains, valleys, and beaches across Pakistan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            crossFadeState:
                _showFirstSlogan ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 700),
          ),

          const SizedBox(height: 26),

          ScaleTransition(
            scale: _scaleAnimation,
            child: const Icon(Icons.flight_takeoff, size: 72, color: Colors.teal),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProfileApp',
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    // Detect orientation
    var orientation = MediaQuery.of(context).orientation;
    String currentOrientation =
        orientation == Orientation.portrait ? "Portrait" : "Landscape";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Screen"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/profile.png'),
                // You can replace with Icon if image not available:
                // child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),

              // RichText (Name and Email)
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Mahboob Rasheed\n",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "mahboob@example.com",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Row with Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Edit Profile pressed")),
                      );
                    },
                    child: const Text("Edit Profile"),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Logout pressed")),
                      );
                    },
                    child: const Text("Logout"),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Container with background and description
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "I’m a passionate Flutter developer who loves building beautiful, responsive, and efficient apps for mobile and web platforms.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),

              // TextField with validation
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Edit Username",
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: _validateInput,
                child: const Text("Save Username"),
              ),
              const SizedBox(height: 24),

              // Orientation display
              Text(
                "Current Orientation: $currentOrientation",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateInput() {
    setState(() {
      if (_usernameController.text.trim().isEmpty) {
        _errorMessage = "Username cannot be empty!";
      } else {
        _errorMessage = null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Username saved: ${_usernameController.text}")),
        );
      }
    });
  }
}

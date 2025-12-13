import 'package:ecommerce_app/signup.dart';
import 'package:ecommerce_app/login.dart';
import 'package:ecommerce_app/home_screen.dart';
import 'package:ecommerce_app/firebase_service.dart';
import 'package:ecommerce_app/cart_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

// Firebase configuration
const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyApnRaX_gxzrShjAnFTJMApLIYUNuLAjjg",
  authDomain: "ecommerce-mobile-app-6a999.firebaseapp.com",
  projectId: "ecommerce-mobile-app-6a999",
  storageBucket: "ecommerce-mobile-app-6a999.firebasestorage.app",
  messagingSenderId: "783545382998",
  appId: "1:783545382998:web:e52e09d315a7e68bc9e3f7",
  measurementId: "G-TZ57BD1GZK",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Web platform check using kIsWeb 
    if (kIsWeb) {
      // For Web platform
      await Firebase.initializeApp(options: firebaseConfig);
    } else {
      // For Mobile platforms (Android/iOS)
      await Firebase.initializeApp();
    }
  } catch (e) {

    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => FirebaseService()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Shopping Destination',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
        ),
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => const Login(),
          '/signup': (context) => const Signup(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading screen while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }

        // Check if user is logged in
        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in - Load cart data
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final cartProvider = Provider.of<CartProvider>(context, listen: false);
            cartProvider.initialize();
          });
          return const HomeScreen();
        }

        // User is not logged in
        return const GetStartedScreen();
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'Loading Retail Shop...',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Version: 1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Keep your existing GetStartedScreen class as is...

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top spacing
              const SizedBox(height: 60),

              // App Title
              const Text(
                'Discover Your\nStyle',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),

              // Subtitle
              const SizedBox(height: 8),
              const Text(
                'Shop the Best Trends',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              // Spacing
              const SizedBox(height: 40),

              // Description Text
              const Text(
                'Explore a wide range of products tailored just for you. Fast shipping, secure checkout, and 24/7 support.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),

              // Flexible spacer to push content up
              const Spacer(),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Signup()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6A11CB),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "Let's Get Started",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Sign In Section
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom spacing
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
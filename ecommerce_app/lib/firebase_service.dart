import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Initialize Firebase
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyApnRaX_gxzrShjAnFTJMApLIYUNuLAjjg",
        authDomain: "ecommerce-mobile-app-6a999.firebaseapp.com",
        projectId: "ecommerce-mobile-app-6a999",
        storageBucket: "ecommerce-mobile-app-6a999.firebasestorage.app",
        messagingSenderId: "783545382998",
        appId: "1:783545382998:web:e52e09d315a7e68bc9e3f7",
        measurementId: "G-TZ57BD1GZK",
      ),
    );
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get user ID
  String? get userId => _auth.currentUser?.uid;

  // Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

  // Email Sign Up
  Future<Map<String, dynamic>> signUpWithEmail(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user!.updateDisplayName(name);

      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'phone': '',
        'address': '',
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'role': 'customer',
        'cartCount': 0,
        'orderCount': 0,
        'totalSpent': 0.0,
      });

      return {'success': true, 'message': 'Registration successful!'};
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Registration failed.';

      if (e.code == 'weak-password') {
        errorMessage = 'Password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Email is already registered.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address.';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred.'};
    }
  }

  // Email Login
  Future<Map<String, dynamic>> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return {'success': true, 'message': 'Login successful!'};
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed.';

      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage = 'Invalid email or password.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'Account has been disabled.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many attempts. Try again later.';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred.'};
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Reset Password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {'success': true, 'message': 'Password reset email sent!'};
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Failed to send reset email.';

      if (e.code == 'user-not-found') {
        errorMessage = 'No account found with this email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address.';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred.'};
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      // print('Get user data error: $e');
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        ...data,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      // print('Update profile error: $e');
      rethrow;
    }
  }
}
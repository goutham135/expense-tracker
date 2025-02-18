import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up Method
  Future<String?> signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  // Login Method
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  // Logout Method
  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<Object?> logIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (kDebugMode) {
          return getErrorMessage(e.code);
        }
      }
      return null;
    }
  }


  Future<void> logOut() async {
    await _auth.signOut();
  }


  String getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'invalid-credential':
        return 'Invalid credentials. Please enter correct email and password';
      default:
        return 'An unknown error occurred.';
    }
  }

  Future<Object?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        return getErrorMessage(e.code);
      }
      return null;
    }
  }



}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '/services/auth_service.dart';

// class AuthNotifier extends ChangeNotifier {
//   final AuthService _authService = AuthService();
//   User? userAuth;

//   User? get user => userAuth;

//   Future<void> signIn(String email, String password) async {
//     UserCredential userCredential =
//         await _authService.signInWithEmailAndPassword(email, password);
//     userAuth = userCredential.user;
//     notifyListeners();
//   }

//   Future<void> signOut() async {
//     await _authService.signOut();
//     userAuth = null;
//     notifyListeners();
//   }
// }

// lib/services/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import '../screens/auth_gate.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      // L'utilisateur est connecté, on affiche la page d'accueil
      return const HomeScreen();
    }
    // L'utilisateur n'est pas connecté, on affiche le portail d'authentification
    return const AuthGate();
  }
}
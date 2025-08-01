// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      // 1. Création de l'utilisateur dans Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // 2. Ajout des informations dans Firestore
      if (user != null) {
        print("Utilisateur créé dans Auth. Tentative d'écriture dans Firestore...");
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'createdAt': Timestamp.now(),
        });
        print("Écriture dans Firestore réussie pour l'utilisateur ${user.uid}");
      }
      return user;

    } catch (e) {
      // Si une erreur se produit, elle sera affichée ici
      print("ERREUR LORS DE L'INSCRIPTION OU DE L'ECRITURE DANS FIRESTORE : $e");
      return null;
    }
  }

  // Le reste du fichier ne change pas...
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
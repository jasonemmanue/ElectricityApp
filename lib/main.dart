// lib/main.dart (CLIENT - Mis à jour avec l'écran de chargement animé)
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/auth_wrapper.dart';
import 'screens/animated_loading_screen.dart'; // <-- 1. Importez l'écran de chargement

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().user,
          initialData: null,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SosElectricity', // Le nom de votre application
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey.shade200,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
          )),
      // 2. Affichez l'écran de chargement animé en premier.
      // Il naviguera vers AuthWrapper après 3 secondes.
      home: const AnimatedLoadingScreen(nextScreen: AuthWrapper()),
      debugShowCheckedModeBanner: false,
    );
  }
}
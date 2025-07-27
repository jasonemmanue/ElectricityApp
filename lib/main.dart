import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOS_ELECTRICITY',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey.shade200,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
          )
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
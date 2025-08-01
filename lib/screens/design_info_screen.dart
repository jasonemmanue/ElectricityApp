// lib/screens/design_info_screen.dart
import 'package:flutter/material.dart';

class DesignInfoScreen extends StatelessWidget {
  const DesignInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Conception'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nos services de conception électrique',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Nous vous accompagnons dans la planification et la conception de vos installations électriques, en garantissant la conformité avec les normes en vigueur (NF C 15-100).',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text('Schémas électriques complets'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text('Dimensionnement des protections'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text('Installation d\'inverseurs de source (manuel/automatique)'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class RenovationInfoScreen extends StatelessWidget {
  const RenovationInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Rénovation'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rénovation de vos installations',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Nous modernisons vos installations électriques pour garantir sécurité, conformité et performance. Que ce soit pour une rénovation complète ou une mise à niveau, nous avons la solution.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.flash_on, color: Colors.orange),
              title: Text('Mise en conformité du tableau électrique'),
            ),
            ListTile(
              leading: Icon(Icons.cable, color: Colors.orange),
              title: Text('Remplacement du câblage et des prises'),
            ),
            ListTile(
              leading: Icon(Icons.lightbulb_outline, color: Colors.orange),
              title: Text('Installation de circuits spécialisés (cuisine, etc.)'),
            ),
          ],
        ),
      ),
    );
  }
}
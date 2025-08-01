// lib/screens/support_screen.dart
import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Client'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contactez-nous',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            const Card(
              child: ListTile(
                leading: Icon(Icons.phone),
                title: Text('Par téléphone'),
                subtitle: Text('+237 698 452 376'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.email),
                title: Text('Par email'),
                subtitle: Text('Kammeugnejulio41@gmail.com'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Adresse'),
                subtitle: Text('407 Rue ESSOMBA, YAOUNDE CAMEROUN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
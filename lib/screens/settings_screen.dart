// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'support_screen.dart'; // <-- AJOUTEZ CETTE LIGNE

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Modifier le profil'),
            onTap: () {
              // TODO: Naviguer vers une page d'édition de profil
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Changer le mot de passe'),
            onTap: () {
              // TODO: Implémenter la logique de changement de mot de passe
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            onTap: () {
              // TODO: Naviguer vers les paramètres de notification
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Langue'),
            onTap: () {
              // TODO: Implémenter la logique de changement de langue
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Aide et Support'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SupportScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;
  bool _whatsappIntegrated = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 32),
              _buildStatsCard(),
              const SizedBox(height: 16),
              _buildPreferencesCard(),
              const SizedBox(height: 32),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue,
          child: Icon(Icons.person, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 12),
        const Text(
          'Marie ATANGANA',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Client depuis Mars 2025',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.bar_chart, color: Colors.purple),
                SizedBox(width: 8),
                Text('Statistiques', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            _buildStatRow('Services demandés:', '12'),
            const SizedBox(height: 8),
            _buildStatRow('Évaluations données:', '8'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Note moyenne donnée:', style: TextStyle(fontSize: 16)),
                const Spacer(),
                const Icon(Icons.star, color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                const Text('4.5/5', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String title, String value) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPreferencesCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.tune, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text('Préférences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            _buildSwitchRow('Notifications push', _pushNotifications, (value) {
              setState(() {
                _pushNotifications = value;
              });
            }),
            _buildSwitchRow('WhatsApp intégré', _whatsappIntegrated, (value) {
              setState(() {
                _whatsappIntegrated = value;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow(String title, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        const Spacer(),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.green,
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Logique de déconnexion
      },
      icon: const Icon(Icons.logout, color: Colors.white),
      label: const Text('Se déconnecter'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
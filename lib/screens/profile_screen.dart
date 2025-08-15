import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/auth_service.dart';

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
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = context.watch<User?>();

    return Container(
      color: Colors.grey.shade200,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            children: [
              _buildProfileHeader(user, context),
              const SizedBox(height: 32),
              _buildStatsCard(),
              const SizedBox(height: 16),
              _buildPreferencesCard(),
              const SizedBox(height: 32),
              _buildLogoutButton(authService),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User? user, BuildContext context) {
    final creationDate = user?.metadata.creationTime;
    // Formatte la date en utilisant la locale actuelle de l'application
    final formattedDate = creationDate != null
        ? DateFormat('MMMM yyyy', context.locale.toString()).format(creationDate)
        : '...';

    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue,
          child: Icon(Icons.person, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          user?.email ?? 'Utilisateur Anonyme',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          // --- CORRECTION ICI ---
          // On utilise 'namedArgs' pour remplacer le placeholder {date}
          'memberSince'.tr(namedArgs: {'date': formattedDate}),
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
            Row(
              children: [
                const Icon(Icons.bar_chart, color: Colors.purple),
                const SizedBox(width: 8),
                Text('stats'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            _buildStatRow('servicesRequested'.tr(), '12'),
            const SizedBox(height: 8),
            _buildStatRow('ratingsGiven'.tr(), '8'),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('avgRatingGiven'.tr(), style: const TextStyle(fontSize: 16)),
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
            Row(
              children: [
                const Icon(Icons.tune, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text('preferences'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            _buildSwitchRow('pushNotifications'.tr(), _pushNotifications, (value) {
              setState(() {
                _pushNotifications = value;
              });
            }),
            _buildSwitchRow('whatsappIntegrated'.tr(), _whatsappIntegrated, (value) {
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

  Widget _buildLogoutButton(AuthService authService) {
    return ElevatedButton.icon(
      onPressed: () async {
        await authService.signOut();
      },
      icon: const Icon(Icons.logout, color: Colors.white),
      label: Text('logout'.tr()),
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

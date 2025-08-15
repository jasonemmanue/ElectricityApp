import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'support_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settingsTitle'.tr()),
        backgroundColor: Colors.blue.shade800,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('language'.tr()),
            trailing: DropdownButton<Locale>(
              value: context.locale,
              items: const [
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
                DropdownMenuItem(value: Locale('fr'), child: Text('Français')),
              ],
              onChanged: (locale) {
                if (locale != null) {
                  context.setLocale(locale);
                }
              },
            ),
          ),
          // "Modifier profil" a été retiré
          // "Changer mot de passe" a été retiré
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text('notifications'.tr()),
            onTap: () {
              // TODO: Naviguer vers les paramètres de notification
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text('helpSupport'.tr()),
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

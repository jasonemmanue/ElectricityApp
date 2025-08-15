import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onTap;
  const LoginScreen({Key? key, required this.onTap}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('loginTitle'.tr()),
        actions: [
          // Widget pour changer de langue
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<Locale>(
              value: context.locale,
              icon: const Icon(Icons.language, color: Colors.white),
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: Locale('en'), child: Text('🇺🇸 English')),
                DropdownMenuItem(value: Locale('fr'), child: Text('🇫🇷 Français')),
              ],
              onChanged: (locale) {
                if (locale != null) {
                  context.setLocale(locale);
                }
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'email'.tr()),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'password'.tr()),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authService.signInWithEmailAndPassword(
                  _emailController.text,
                  _passwordController.text,
                );
              },
              child: Text('signIn'.tr()),
            ),
            TextButton(
              onPressed: widget.onTap,
              child: Text('dontHaveAnAccount'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
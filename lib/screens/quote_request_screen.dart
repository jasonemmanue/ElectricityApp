// lib/screens/quote_request_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuoteRequestScreen extends StatefulWidget {
  const QuoteRequestScreen({Key? key}) : super(key: key);

  @override
  _QuoteRequestScreenState createState() => _QuoteRequestScreenState();
}

class _QuoteRequestScreenState extends State<QuoteRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController(); // Nouveau contrôleur
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // --- NOUVELLE FONCTION POUR ENVOYER LE DEVIS DANS LE CHAT ---
  void _submitQuoteRequest() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur : Vous devez être connecté.')),
        );
        return;
      }

      // 1. On construit le message formaté
      final String quoteMessage = """
Demande de Devis:

**Objet du dépannage:**
${_subjectController.text}

**Description du problème:**
${_descriptionController.text}

**Adresse:**
${_addressController.text}
""";

      // 2. On envoie ce message dans la conversation du client
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(user.uid)
          .collection('messages')
          .add({
        'text': quoteMessage,
        'senderId': user.uid, // L'expéditeur est le client
        'timestamp': Timestamp.now(),
      });

      // 3. On met à jour le chat principal pour la notification de l'admin
      await FirebaseFirestore.instance.collection('chats').doc(user.uid).set({
        'lastMessageAt': Timestamp.now(),
        'userEmail': user.email,
        'userId': user.uid,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demande de devis envoyée dans le chat !')),
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demande de Devis'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- CHAMP OBJET AJOUTÉ ---
              const Text('Objet du dépannage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  hintText: 'Ex: Panne de courant, installation prise...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Veuillez définir un objet' : null,
              ),
              const SizedBox(height: 24),
              const Text('Description de votre projet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Décrivez les travaux que vous souhaitez faire réaliser...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Veuillez fournir une description' : null,
              ),
              const SizedBox(height: 24),
              const Text('Adresse du projet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: 'Votre adresse complète',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Veuillez fournir une adresse' : null,
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _submitQuoteRequest, // On appelle la nouvelle fonction
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Envoyer la demande'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
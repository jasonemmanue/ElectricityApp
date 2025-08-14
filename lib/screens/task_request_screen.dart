// lib/screens/task_request_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskRequestScreen extends StatefulWidget {
  // --- MODIFICATION ICI : "const" a été retiré ---
  const TaskRequestScreen({super.key});

  @override
  _TaskRequestScreenState createState() => _TaskRequestScreenState();
}

class _TaskRequestScreenState extends State<TaskRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _objectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _submitTaskRequest() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur : Vous devez être connecté.')),
        );
        return;
      }

      final String taskMessage = """
**Prestation de service (Travaux à la tâche)**

**Objet:**
${_objectController.text}

**Description du travail:**
${_descriptionController.text}
""";

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(user.uid)
          .collection('messages')
          .add({
        'text': taskMessage,
        'senderId': user.uid,
        'timestamp': Timestamp.now(),
      });

      await FirebaseFirestore.instance.collection('chats').doc(user.uid).set({
        'lastMessageAt': Timestamp.now(),
        'userEmail': user.email,
        'userId': user.uid,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demande de service envoyée dans le chat !')),
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
        title: const Text('Prestation de services'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Objet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _objectController,
                decoration: const InputDecoration(
                  hintText: 'Ex: Installation d\'une nouvelle prise',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Veuillez définir un objet' : null,
              ),
              const SizedBox(height: 24),
              const Text('Description du travail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Décrivez le travail à effectuer...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Veuillez fournir une description' : null,
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _submitTaskRequest,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Envoyer'),
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
    _objectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
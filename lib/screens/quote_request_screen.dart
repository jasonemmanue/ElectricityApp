import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class QuoteRequestScreen extends StatefulWidget {
  const QuoteRequestScreen({Key? key}) : super(key: key);

  @override
  _QuoteRequestScreenState createState() => _QuoteRequestScreenState();
}

class _QuoteRequestScreenState extends State<QuoteRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _submitQuoteRequest() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur : Vous devez être connecté.')),
        );
        return;
      }

      final String quoteMessage = """
Demande de Devis:

**Objet du dépannage:**
${_subjectController.text}

**Description du problème:**
${_descriptionController.text}

**Adresse:**
${_addressController.text}
""";

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(user.uid)
          .collection('messages')
          .add({
        'text': quoteMessage,
        'senderId': user.uid,
        'timestamp': Timestamp.now(),
      });

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
        title: Text('quoteRequestTitle'.tr()),
        backgroundColor: Colors.blue.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('troubleshootingSubject'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  hintText: 'subjectPlaceholder'.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'pleaseDefineSubject'.tr() : null,
              ),
              const SizedBox(height: 24),
              Text('projectDescription'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'projectDescriptionPlaceholder'.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'pleaseProvideDescription'.tr() : null,
              ),
              const SizedBox(height: 24),
              Text('projectAddress'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'yourFullAddress'.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'pleaseProvideAddress'.tr() : null,
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _submitQuoteRequest,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text('sendRequest'.tr()),
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

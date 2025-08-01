// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_message.dart'; // Bien que non utilisé directement, il est bon de le garder pour référence

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty || user == null) return;

    final userUid = user!.uid;
    final userEmail = user!.email;
    _textController.clear();

    // 1. Ajoute le nouveau message à la sous-collection
    FirebaseFirestore.instance
        .collection('chats')
        .doc(userUid) // Le document principal du chat porte l'UID du client
        .collection('messages') // La sous-collection contient les messages
        .add({
      'text': text,
      'senderId': userUid, // L'ID de l'expéditeur est celui du client
      'timestamp': Timestamp.now(),
    });

    // 2. Met à jour le document principal pour un tri facile côté admin
    FirebaseFirestore.instance.collection('chats').doc(userUid).set({
      'lastMessageAt': Timestamp.now(),
      'userEmail': userEmail, // Facilite l'affichage dans la liste admin
      'userId': userUid,
    }, SetOptions(merge: true)); // 'merge: true' pour ne pas écraser les données existantes
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(
        child: Text("Veuillez vous connecter pour accéder au chat."),
      );
    }

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .doc(user!.uid)
                .collection('messages')
                .orderBy('timestamp', descending: true) // Les plus récents en premier
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Démarrez la conversation !"));
              }

              final messages = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                reverse: true, // Affiche la liste en partant du bas
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var messageData = messages[index].data() as Map<String, dynamic>;
                  return _buildMessageBubble(messageData);
                },
              );
            },
          ),
        ),
        _buildMessageComposer(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange.shade700,
            child: const Text('I', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          const Text(
            'Chat ElectriPro',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.call, color: Colors.red.shade700),
            onPressed: () { /* Logique d'appel à implémenter */ },
          )
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    // On vérifie si le message a été envoyé par l'utilisateur actuel ou par l'admin
    final isMe = message['senderId'] == user!.uid;
    final senderName = isMe ? 'Vous' : 'Électricien';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue.shade600 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  senderName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message['text'] ?? '',
                  style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.grey.shade300,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Tapez votre message...',
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
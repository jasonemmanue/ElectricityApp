// lib/screens/chat_screen.dart

import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      sender: 'Électricien',
      text: 'Bonjour ! J\'ai bien reçu votre demande de dépannage. Pouvez-vous me décrire le problème plus précisément ?',
      isSentByMe: false,
    ),
    ChatMessage(
      sender: 'Vous',
      text: 'Bonjour, j\'ai une panne de courant dans ma cuisine depuis ce matin. Les autres pièces fonctionnent normalement.',
      isSentByMe: true,
    ),
    ChatMessage(
      sender: 'Électricien',
      text: 'D\'accord, cela ressemble à un problème de disjoncteur. Je peux passer cet après-midi vers 15h. Le diagnostic coûte 50€.',
      isSentByMe: false,
    ),
  ];

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.add(
        ChatMessage(
          sender: 'Vous',
          text: text,
          isSentByMe: true,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            reverse: false, // Pour afficher l'historique du plus ancien au plus récent
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return _buildMessageBubble(_messages[index]);
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
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isMe = message.isSentByMe;
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
              borderRadius: isMe
                  ? const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )
                  : const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message.sender,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.text,
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
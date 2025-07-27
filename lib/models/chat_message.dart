// lib/models/chat_message.dart

class ChatMessage {
  final String text;
  final String sender;
  final bool isSentByMe;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.isSentByMe,
  });
}
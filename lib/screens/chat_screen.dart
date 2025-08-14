import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../widgets/message_bubble.dart';
import '../services/encryption_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EncryptionService _encryptionService = EncryptionService();

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  DocumentSnapshot? _replyingTo;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null);
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    final user = _auth.currentUser;
    if (user == null) return;

    final encryptedText = _encryptionService.encryptText(_messageController.text);

    Map<String, dynamic> messageData = {
      'text': encryptedText,
      'senderId': user.uid,
      'timestamp': Timestamp.now(),
      // --- CORRECTION MAJEURE ICI ---
      // On utilise directement le champ 'text' (déjà chiffré) du message original.
      if (_replyingTo != null)
        'replyingTo': {
          'messageId': _replyingTo!.id,
          'text': _replyingTo!['text'], // On prend le texte déjà chiffré.
        }
    };

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(user.uid)
        .collection('messages')
        .add(messageData);

    await FirebaseFirestore.instance.collection('chats').doc(user.uid).set({
      'lastMessageAt': Timestamp.now(),
      'userEmail': user.email,
      'userId': user.uid,
    }, SetOptions(merge: true));

    _messageController.clear();
    setState(() {
      _replyingTo = null;
    });
  }

  void _scrollToMessage(String messageId, List<DocumentSnapshot> messages) {
    final index = messages.indexWhere((doc) => doc.id == messageId);
    if (index != -1) {
      _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        alignment: 0.5, // Centre le message sur l'écran
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le message d'origine n'est plus visible.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser?.uid;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: userId == null
                ? const Center(child: Text("Connectez-vous pour voir le chat."))
                : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(userId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Aucun message."));
                }

                final messages = snapshot.data!.docs;
                // Sauter au dernier message à l'ouverture
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_itemScrollController.isAttached) {
                    _itemScrollController.jumpTo(index: messages.length - 1);
                  }
                });

                return _buildMessagesList(messages);
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessagesList(List<DocumentSnapshot> messages) {
    return ScrollablePositionedList.builder(
      itemCount: messages.length,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
      itemBuilder: (context, index) {
        final messageDoc = messages[index];
        final messageData = messageDoc.data() as Map<String, dynamic>;

        final decryptedText = _encryptionService.decryptText(messageData['text']);
        final messageTimestamp = (messageData['timestamp'] as Timestamp).toDate();

        // --- Logique améliorée pour les séparateurs de date ---
        bool showDateSeparator = false;
        if (index == 0) {
          showDateSeparator = true;
        } else {
          final prevMessageData = messages[index - 1].data() as Map<String, dynamic>;
          final prevTimestamp = (prevMessageData['timestamp'] as Timestamp).toDate();
          if (messageTimestamp.day != prevTimestamp.day ||
              messageTimestamp.month != prevTimestamp.month ||
              messageTimestamp.year != prevTimestamp.year) {
            showDateSeparator = true;
          }
        }

        final isMe = _auth.currentUser!.uid == messageData['senderId'];
        final replyData = messageData['replyingTo'] as Map<String, dynamic>?;
        final decryptedRepliedText = replyData != null
            ? _encryptionService.decryptText(replyData['text'])
            : null;

        final messageBubble = Dismissible(
          key: Key(messageDoc.id),
          direction: DismissDirection.startToEnd,
          onDismissed: (_) { setState(() { _replyingTo = messageDoc; }); },
          background: Container(
            color: Colors.blue.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: const Icon(Icons.reply, color: Colors.blue),
          ),
          child: MessageBubble(
            text: decryptedText,
            sender: messageData['senderId'],
            timestamp: messageTimestamp,
            isMe: isMe,
            repliedText: decryptedRepliedText,
            onQuoteTap: replyData == null
                ? null
                : () => _scrollToMessage(replyData['messageId'], messages),
          ),
        );

        if (showDateSeparator) {
          return Column(
            children: [
              _buildDateSeparator(messageTimestamp),
              messageBubble,
            ],
          );
        }
        return messageBubble;
      },
    );
  }

  String _formatDateSeparator(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCompare = DateTime(date.year, date.month, date.day);

    if (dateToCompare == today) return "Aujourd'hui";
    if (dateToCompare == yesterday) return "Hier";
    return DateFormat.yMMMMEEEEd('fr_FR').format(date);
  }

  Widget _buildDateSeparator(DateTime date) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _formatDateSeparator(date),
          style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
    final replyingToText = _replyingTo != null
        ? _encryptionService.decryptText(_replyingTo!['text'])
        : null;

    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_replyingTo != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )
              ),
              child: Row(
                children: [
                  const Icon(Icons.reply, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "En réponse à : $replyingToText",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () { setState(() { _replyingTo = null; }); },
                  )
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Écrire un message...',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
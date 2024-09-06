import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gesttick/models/message.dart';
import 'package:gesttick/models/ticket.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  ChatScreen({required this.receiverId, required this.receiverName, required String ticketId, required Ticket ticket});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _sendMessage() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null && _messageController.text.isNotEmpty) {
      final message = Message(
        senderId: currentUser.uid,
        receiverId: widget.receiverId,
        text: _messageController.text,
        timestamp: Timestamp.now(),
      );

      await _firestore.collection('chats').add(message.toMap());
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Bienvenue sur la file de discusion ${widget.receiverName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs
                    .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
                    .toList();
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message.text),
                      subtitle: Text(
                        message.senderId == _auth.currentUser!.uid
                            ? 'You'
                            : widget.receiverName,
                      ),
                      trailing: Text(
                        message.timestamp.toDate().toLocal().toString(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

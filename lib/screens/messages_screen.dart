import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educonnect/models/chat.dart';
import 'package:educonnect/models/message.dart';
import 'package:educonnect/services/message_service.dart';

class MessagesScreen extends StatefulWidget {
  static const String id = "messagesScreen";
  final Chat chat;
  final String currentUserId;

  const MessagesScreen({
    Key? key,
    required this.chat,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final MessageService _messageService = MessageService();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final message = Message(
        id: '',
        chatId: widget.chat.id,
        message: _messageController.text,
        senderId: widget.currentUserId,
        receiverId: widget.chat.tutorId == widget.currentUserId
            ? widget.chat.studentId
            : widget.chat.tutorId,
        timestamp: Timestamp.now(),
      );
      await _messageService.sendMessage(message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messages with ${widget.chat.tutorId == widget.currentUserId ? widget.chat.studentName : widget.chat.tutorName}')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _messageService.getMessagesStream(widget.chat.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Container(
                        alignment: message.senderId == widget.currentUserId
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        color: message.senderId == widget.currentUserId
                            ? Colors.blue[100]
                            : Colors.grey[300],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            message.message,
                            textAlign: message.senderId == widget.currentUserId
                                ? TextAlign.right
                                : TextAlign.left,
                          ),
                        ),
                      ),
                      subtitle: Text(
                          'Sent by ${message.senderId == widget.chat.tutorId ? widget.chat.tutorName : widget.chat.studentName}'),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type your message here..",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

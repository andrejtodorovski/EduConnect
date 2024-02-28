import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educonnect/helpers/colors.dart';
import 'package:educonnect/models/chat.dart';
import 'package:educonnect/models/message.dart';
import 'package:educonnect/services/message_service.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  static const String id = "messagesScreen";
  final Chat? chat;
  final String? currentUserId;

  const MessagesScreen({
    Key? key,
    this.chat,
    this.currentUserId,
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
        chatId: widget.chat!.id,
        message: _messageController.text,
        senderId: widget.currentUserId!,
        receiverId: widget.chat!.tutorId == widget.currentUserId
            ? widget.chat!.studentId
            : widget.chat!.tutorId,
        timestamp: Timestamp.now(),
      );
      await _messageService.sendMessage(message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.chat!.tutorId == widget.currentUserId
              ? widget.chat!.studentName
              : widget.chat!.tutorName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _messageService.getMessagesStream(widget.chat!.id),
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
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final bool isSentByCurrentUser =
                        message.senderId == widget.currentUserId;
                    return Align(
                      alignment: isSentByCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 14),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: isSentByCurrentUser
                              ? green
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: isSentByCurrentUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.message,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              message.timestamp.toDate().toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle
                                    .italic,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                      hintText: "Внеси ја твојата порака тука..",
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

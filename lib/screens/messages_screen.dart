import 'package:educonnect/models/chat.dart';
import 'package:educonnect/models/message.dart';
import 'package:educonnect/services/auth_service.dart';
import 'package:educonnect/services/message_service.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  static const String id = "messagesScreen";

  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  Chat? selectedChat;
  final MessageService _messageService = MessageService();
  String currentUserId = AuthService().currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              child: StreamBuilder<List<Chat>>(
                stream: _messageService.getTutorsChatsStream(currentUserId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final chats = snapshot.data!;
                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return ListTile(
                        title: Text(
                            'Chat with ${chat.tutorId == currentUserId ? chat.studentName : chat.tutorName}'),
                        onTap: () {
                          setState(() {
                            selectedChat = chat;
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: selectedChat == null
                  ? const Center(child: Text('Select a chat to view messages'))
                  : StreamBuilder<List<Message>>(
                      stream: _messageService.getMessagesStream(selectedChat!.id),
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
                                alignment: message.senderId == currentUserId
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                color: message.senderId == currentUserId
                                    ? Colors.blue[100]
                                    : Colors.grey[300],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    message.message,
                                    textAlign: message.senderId == currentUserId
                                        ? TextAlign.right
                                        : TextAlign.left,
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                  'Sent by ${message.senderId == selectedChat!.tutorId ? selectedChat!.tutorName : selectedChat!.studentName}'),
                            );
                            // TODO() Add a text field and a button to send a message and improve styling
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

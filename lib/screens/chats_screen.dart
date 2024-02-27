import 'package:flutter/material.dart';
import 'package:educonnect/models/chat.dart';
import 'package:educonnect/services/auth_service.dart';
import 'package:educonnect/services/message_service.dart';
import '../models/user.dart';
import 'messages_screen.dart';

class ChatsScreen extends StatefulWidget {
  static const String id = "chatsScreen";

  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final MessageService _messageService = MessageService();
  String currentUserId = AuthService().currentUser!.uid;

  Future<MyUser> getUserData() async {
    return await AuthService().getUserById(AuthService().currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: FutureBuilder<MyUser>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            MyUser currentUser = snapshot.data!;
            bool isTutor = currentUser.role == 'tutor';
            return StreamBuilder<List<Chat>>(
              stream: isTutor
                  ? _messageService.getTutorsChatsStream(currentUserId)
                  : _messageService.getStudentsChatsStream(currentUserId),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessagesScreen(
                              chat: chat,
                              currentUserId: currentUserId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

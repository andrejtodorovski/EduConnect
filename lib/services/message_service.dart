import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educonnect/models/chat.dart';

import '../models/message.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Message>> getMessagesStream(String chatId) {
    return _firestore
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Message.fromJson(doc.id, doc.data()))
          .toList();
    });
  }

  void createChatAndSendHelloMessage(String tutorId, String studentId, String tutorName, String studentName) {
    final chat = Chat(id: '', tutorId: tutorId, tutorName: tutorName, studentId: studentId, studentName: studentName);
    Map<String, dynamic> chatData = chat.toJson();
    chatData.remove('id');
    _firestore.collection('chats').add(chatData).then((docRef) {
      final message = Message(
        id: '',
        chatId: docRef.id,
        message: 'Hello!',
        senderId: studentId,
        receiverId: tutorId,
        timestamp: Timestamp.now(),
      );
      sendMessage(message);
    });
  }

  Stream<List<Chat>> getTutorsChatsStream(String userId) {
    return _firestore
        .collection('chats')
        .where('tutorId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Chat.fromJson(doc.id, doc.data()))
          .toList();
    });
  }

  Stream<List<Chat>> getStudentsChatsStream(String userId) {
    return _firestore
        .collection('chats')
        .where('studentId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Chat.fromJson(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> sendMessage(Message message) async {
    Map<String, dynamic> messageData = message.toJson();
    messageData.remove('id');
    await _firestore.collection('messages').add(messageData).then((docRef) {});
  }
}

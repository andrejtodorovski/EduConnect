import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String chatId;
  final String message;
  final String senderId;
  final String receiverId;
  final Timestamp timestamp;

  Message({
    required this.id,
    required this.chatId,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
  });

  static Message fromJson(String id, Map<String, dynamic> json) {
    return Message(
      id: id,
      chatId: json['chatId'],
      message: json['message'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp,
    };
  }
}

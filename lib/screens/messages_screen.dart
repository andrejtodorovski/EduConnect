import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  static const String id = "messagesScreen";
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пораки'),
      ),
      body: const Center(
        child: Text('Your messages will be displayed here'),
      ),
    );
  }
}
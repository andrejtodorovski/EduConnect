import 'package:flutter/material.dart';

class SavedCoursesScreen extends StatelessWidget {
  static const String id = "savedCoursesScreen";

  const SavedCoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Courses'),
      ),
      body: const Center(
        child: Text('Your saved courses will be displayed here'),
      ),
    );
  }
}
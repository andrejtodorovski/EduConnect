import 'package:educonnect/screens/home_screen.dart';
import 'package:educonnect/services/course_service.dart';
import 'package:educonnect/widgets/error_message.dart';
import 'package:educonnect/widgets/text_entry_field.dart';
import 'package:flutter/material.dart';

class AddCourseScreen extends StatefulWidget {
  static const String id = "loginPage";

  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  String? errorMessage = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _schoolNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void addCourse() async {
    if (_nameController.text.isEmpty || _schoolNameController.text.isEmpty) {
      setState(() => errorMessage = 'Пополнете ги сите полиња');
      return;
    }

    await CourseService()
        .createCourse(_nameController.text, _schoolNameController.text)
        .then((value) => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()))
            });
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: addCourse,
        child: const Text('Додади курс', style: TextStyle(fontSize: 20)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Додади курс'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              entryFieldWidget('Име', _nameController),
              entryFieldWidget('Училиште/Факултет', _schoolNameController),
              errorMessageWidget(errorMessage),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

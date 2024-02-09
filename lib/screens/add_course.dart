import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educonnect/models/course.dart';
import 'package:educonnect/screens/home_screen.dart';
import 'package:educonnect/services/auth_service.dart';
import 'package:educonnect/services/course_service.dart';
import 'package:educonnect/widgets/error_message.dart';
import 'package:educonnect/widgets/text_entry_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/colors.dart';
import '../helpers/images.dart';
import '../models/user.dart';

class AddCourseScreen extends StatefulWidget {
  static const String id = "addCourseScreen";

  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  String? errorMessage = '';
  String _levelOfEducation = 'Основно';
  String _methodOfTeaching = 'Online';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _yearOfStudyController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void addCourse() async {
    final name = _nameController.text;
    final schoolName = _schoolNameController.text;
    final yearOfStudy = int.parse(_yearOfStudyController.text);
    final price = int.parse(_priceController.text);
    final length = int.parse(_lengthController.text);
    final longitude = double.parse(_longitudeController.text);
    final latitude = double.parse(_latitudeController.text);

    if (_nameController.text.isEmpty ||
        _schoolNameController.text.isEmpty ||
        _yearOfStudyController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _lengthController.text.isEmpty ||
        _longitudeController.text.isEmpty ||
        _latitudeController.text.isEmpty) {
      setState(() => errorMessage = 'Пополнете ги сите полиња');
      return;
    }

    MyUser? currentUser = await AuthService().getCurrentUser();
    final tutorName = '${currentUser.firstName} ${currentUser.lastName}';

    final newCourse = Course(
        id: "unique_key",
        name: name,
        schoolName: schoolName,
        educationLevel: _levelOfEducation,
        userId: AuthService().currentUser!.uid,
        tutorName: tutorName,
        yearOfStudy: yearOfStudy,
        methodOfTeaching: _methodOfTeaching,
        price: price,
        length: length,
        location: GeoPoint(latitude, longitude),
        averageRating: 0.0);

    await CourseService().createCourse(newCourse).then((value) => {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()))
        });
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: addCourse,
        child: const Text('Додади курс',
            style: TextStyle(fontSize: 20, color: green)));
  }

  Widget _levelOfEducationRadioButtons() {
    return Column(
      children: [
        const Text('Ниво на образование', style: TextStyle(fontSize: 16)),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: ListTile(
                  title: const Text('Основно',
                      style: TextStyle(fontSize: 10, color: green)),
                  leading: Radio<String>(
                    value: 'Основно',
                    groupValue: _levelOfEducation,
                    onChanged: (String? value) {
                      setState(() {
                        _levelOfEducation = value!;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text('Средно',
                      style: TextStyle(fontSize: 10, color: green)),
                  leading: Radio<String>(
                    value: 'Средно',
                    groupValue: _levelOfEducation,
                    onChanged: (String? value) {
                      setState(() {
                        _levelOfEducation = value!;
                      });
                    },
                  ),
                ),
              ),
            ]),
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text('Високо',
                    style: TextStyle(fontSize: 10, color: green)),
                leading: Radio<String>(
                  value: 'Високо',
                  groupValue: _levelOfEducation,
                  onChanged: (String? value) {
                    setState(() {
                      _levelOfEducation = value!;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                title: const Text('Друго',
                    style: TextStyle(fontSize: 10, color: green)),
                leading: Radio<String>(
                  value: 'Друго',
                  groupValue: _levelOfEducation,
                  onChanged: (String? value) {
                    setState(() {
                      _levelOfEducation = value!;
                    });
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _methodOfTeachingRadioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: const Text('Online',
                style: TextStyle(fontSize: 10, color: green)),
            leading: Radio<String>(
              value: 'Online',
              groupValue: _methodOfTeaching,
              onChanged: (String? value) {
                setState(() {
                  _methodOfTeaching = value!;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text('Со физичко присуство',
                style: TextStyle(fontSize: 10, color: green)),
            leading: Radio<String>(
              value: 'Со физичко присуство',
              groupValue: _methodOfTeaching,
              onChanged: (String? value) {
                setState(() {
                  _methodOfTeaching = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _entryFieldWidgetNumbersOnly(
      String title, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              fillColor: Colors.white,
              filled: true,
              label: Text(title,
                  style: const TextStyle(fontSize: 15, color: green)),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              logogreen,
              entryFieldWidget('Име на предмет', _nameController),
              _levelOfEducationRadioButtons(),
              entryFieldWidget('Училиште/Факултет', _schoolNameController),
              _entryFieldWidgetNumbersOnly(
                  'Одделение/Година', _yearOfStudyController),
              _methodOfTeachingRadioButtons(),
              Column(
                children: [
                  const Text('Локација', style: TextStyle(fontSize: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: _entryFieldWidgetNumbersOnly(
                              'Latitude', _latitudeController)),
                      Expanded(
                          child: _entryFieldWidgetNumbersOnly(
                              'Longitude', _longitudeController))
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Цена и времетраење на час',
                      style: TextStyle(fontSize: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: _entryFieldWidgetNumbersOnly(
                              'Цена/час', _priceController)),
                      Expanded(
                          child: _entryFieldWidgetNumbersOnly(
                              'Времетраење на час', _lengthController))
                    ],
                  ),
                ],
              ),
              errorMessageWidget(errorMessage),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

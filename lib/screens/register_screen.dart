import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educonnect/helpers/colors.dart';
import 'package:educonnect/screens/login_screen.dart';
import 'package:educonnect/services/auth_service.dart';
import 'package:educonnect/widgets/error_message.dart';
import 'package:educonnect/widgets/login_link.dart';
import 'package:educonnect/widgets/text_entry_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:educonnect/models/user.dart';

import '../helpers/images.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = "RegisterScreen";

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? errorMessage = '';
  bool hasError = false;
  String _role = 'Студент';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> createUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final phoneNumber = _phoneController.text;
    if (email.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        phoneNumber.isEmpty) {
      setState(() => errorMessage = 'Пополнете ги сите полиња');
      return;
    }
    final users = FirebaseFirestore.instance.collection('users');

    try {
      final result =
          await AuthService().createUserWithEmailAndPassword(email, password);
      final uid = result.user?.uid;
      if (uid != null) {
        final user = MyUser(
          id: uid,
          username: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          role: _role,
          phoneNumber: phoneNumber,
        );

        await users.doc(uid).set(user.toJson()).then((value) => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()))
            });
      }
    } on FirebaseAuthException catch (e) {
      hasError = true;
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: createUser,
        child: const Text('Регистрирај се', style: TextStyle(fontSize: 20, color: green)));
  }

  Widget _userRoleRadioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: const Text('Тутор', style: TextStyle(fontSize: 16, color: green)),
            leading: Radio<String>(
              value: 'Тутор',
              groupValue: _role,
              onChanged: (String? value) {
                setState(() {
                  _role = value!;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text('Студент', style: TextStyle(fontSize: 16, color: green)),
            leading: Radio<String>(
              value: 'Студент',
              groupValue: _role,
              onChanged: (String? value) {
                setState(() {
                  _role = value!;
                });
              },
            ),
          ),
        ),
      ],
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
              const SizedBox(height: 60),
              entryFieldWidget('Име', _firstNameController),
              entryFieldWidget('Презиме', _lastNameController),
              _userRoleRadioButtons(),
              entryFieldWidget('Е-маил', _emailController),
              entryFieldWidget('Телефонски број', _phoneController),
              entryFieldWidget('Лозинка', _passwordController,
                  isPassword: true),
              errorMessageWidget(errorMessage),
              _submitButton(),
              const SizedBox(height: 30),
              loginLinkWidget(context),
            ],
          ),
        ),
      ),
    );
  }
}

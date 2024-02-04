import 'package:educonnect/screens/login_screen.dart';
import 'package:educonnect/services/auth_service.dart';
import 'package:educonnect/widgets/error_message.dart';
import 'package:educonnect/widgets/login_link.dart';
import 'package:educonnect/widgets/text_entry_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = "RegisterScreen";

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? errorMessage = '';
  bool hasError = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> createUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => errorMessage = 'Пополнете ги сите полиња');
      return;
    }

    try {
      await AuthService()
          .createUserWithEmailAndPassword(
              _emailController.text, _passwordController.text)
          .then((value) => {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()))
              });
    } on FirebaseAuthException catch (e) {
      hasError = true;
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() => const Text('Регистрирај се');

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: createUser,
        child: const Text('Регистрирај се', style: TextStyle(fontSize: 20)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              entryFieldWidget('Име', _nameController),
              entryFieldWidget('Презиме', _surnameController),
              entryFieldWidget('Е-маил', _emailController),
              entryFieldWidget('Телефонски број', _phoneController),
              entryFieldWidget('Лозинка', _passwordController,
                  isPassword: true),
              errorMessageWidget(errorMessage),
              _submitButton(),
              const SizedBox(height: 20),
              loginLinkWidget(context),
            ],
          ),
        ),
      ),
    );
  }
}

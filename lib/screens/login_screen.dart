import 'package:educonnect/screens/home_screen.dart';
import 'package:educonnect/services/auth_service.dart';
import 'package:educonnect/widgets/error_message.dart';
import 'package:educonnect/widgets/register_link.dart';
import 'package:educonnect/widgets/text_entry_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "loginPage";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';
  bool hasError = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => errorMessage = 'Пополнете ги сите полиња');
      return;
    }

    try {
      await AuthService()
          .signInWithEmailAndPassword(
              _emailController.text, _passwordController.text)
          .then((value) => {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()))
              });
    } on FirebaseAuthException catch (e) {
      hasError = true;
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() => const Text('Најавете се');

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: signIn,
        child: const Text('Најави се', style: TextStyle(fontSize: 20)));
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
              entryFieldWidget('Е-маил', _emailController),
              entryFieldWidget('Лозинка', _passwordController,
                  isPassword: true),
              errorMessageWidget(errorMessage),
              _submitButton(),
              const SizedBox(height: 20),
              registerLinkWidget(context),
            ],
          ),
        ),
      ),
    );
  }
}

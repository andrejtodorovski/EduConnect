import 'package:educonnect/helpers/colors.dart';
import 'package:educonnect/screens/home_screen.dart';
import 'package:educonnect/widgets/login_link.dart';
import 'package:flutter/material.dart';

import '../helpers/images.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcomeScreen";

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
              color: grey,
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  logogreen,
                  const SizedBox(height: 50),
                  const Text("Регистрирај се како...",
                      style: TextStyle(fontSize: 26, color: green)),
                  const SizedBox(height: 20),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 70),
                      decoration: BoxDecoration(
                        border: Border.all(color: green, width: 2),
                      ),
                      child: Column(
                        children: [
                          tutor,
                          const Text("Тутор", style: TextStyle(fontSize: 26)),
                        ],
                      )),
                  const SizedBox(height: 20),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 60),
                      decoration: BoxDecoration(
                        border: Border.all(color: green, width: 2),
                      ),
                      child: Column(
                        children: [
                          student,
                          const Text("Ученик/Студент",
                              style: TextStyle(fontSize: 26)),
                        ],
                      )),
                  const SizedBox(height: 30),
                  loginLinkWidget(context),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()));
                      },
                      child: const Text("Продолжи како гостин"))
                ],
              )),
        ));
  }
}

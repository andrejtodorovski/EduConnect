import 'package:educonnect/helpers/colors.dart';
import 'package:educonnect/screens/register_screen.dart';
import 'package:flutter/material.dart';

Widget registerLinkWidget(BuildContext context) {
  return Column(
    children: [
      const Text(
        "Немате корисничка сметка?",
        style: TextStyle(color: green),
      ),
      TextButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const RegisterScreen()));
        },
        child: const Text(
          'Регистрирајте се тука.',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: green,
              decoration: TextDecoration.none),
        ),
      ),
    ],
  );
}

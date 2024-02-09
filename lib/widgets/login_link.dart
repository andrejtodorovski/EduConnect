import 'package:educonnect/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../helpers/colors.dart';

Widget loginLinkWidget(BuildContext context) {
  return Column(
    children: [
      const Text(
        "Веќе имате корисничка сметка?",
        style: TextStyle(color: green),
      ),
      TextButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginScreen()));
        },
        child: const Text(
          'Најавете се тука.',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: green,
              decoration: TextDecoration.none),
        ),
      ),
    ],
  );
}

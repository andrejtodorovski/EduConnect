import 'package:educonnect/screens/register_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget registerLinkWidget(BuildContext context) {
  return RichText(
    text: TextSpan(
      children: <TextSpan>[
        const TextSpan(
            text: "Немате сметка? ", style: TextStyle(color: Colors.black)),
        TextSpan(
          text: 'Регистрирајте се тука.',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              decoration: TextDecoration.none),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterScreen()));
            },
        ),
      ],
    ),
  );
}

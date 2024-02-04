import 'package:educonnect/screens/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget loginLinkWidget(BuildContext context) {
  return RichText(
    text: TextSpan(
      children: <TextSpan>[
        const TextSpan(
            text: "Веќе имате корисничка сметка? ",
            style: TextStyle(color: Colors.black)),
        TextSpan(
          text: 'Најавете се тука.',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              decoration: TextDecoration.none),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
        ),
      ],
    ),
  );
}

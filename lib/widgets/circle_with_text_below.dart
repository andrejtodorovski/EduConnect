import 'package:educonnect/helpers/colors.dart';
import 'package:flutter/material.dart';

Widget circleWithTextBelowWidget(String text, {bool showPersonIcon = true}) {
  IconData iconData = showPersonIcon ? Icons.person : Icons.school;

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(
        radius: 30.0,
        backgroundColor: Colors.grey.withOpacity(0.2),
        child: Icon(
          iconData,
          color: green,
          size: 50.0,
        ),
      ),
      const SizedBox(height: 8),
      Text(text),
    ],
  );
}

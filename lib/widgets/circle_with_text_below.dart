import 'package:educonnect/helpers/colors.dart';
import 'package:flutter/material.dart';

Widget circleWithTextBelowWidget(String text, {bool shouldShowImage = false}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.grey,
          child: (shouldShowImage)
              ? const Icon(
                  Icons.person,
                  color: green,
                  size: 50.0,
                )
              : null),
      const SizedBox(height: 8),
      Text(text),
    ],
  );
}

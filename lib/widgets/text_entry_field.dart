import 'package:educonnect/helpers/colors.dart';
import 'package:flutter/material.dart';

Widget entryFieldWidget(String title, TextEditingController controller,
    {bool isPassword = false}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            fillColor: Colors.white,
            filled: true,
            label: Text(title,
                style:
                    const TextStyle(fontSize: 15, color: green)),
          ),
        )
      ],
    ),
  );
}

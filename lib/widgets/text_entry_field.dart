import 'package:flutter/material.dart';

Widget entryFieldWidget(String title, TextEditingController controller,
    {bool isPassword = false}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: const Color(0xfff3f3f4),
            filled: true,
            label: Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        )
      ],
    ),
  );
}

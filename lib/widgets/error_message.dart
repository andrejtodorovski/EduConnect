import 'package:flutter/material.dart';

Widget errorMessageWidget(String? errorMessage) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    alignment: Alignment.center,
    child: Text(errorMessage ?? '',
        style: const TextStyle(color: Colors.red, fontSize: 13)),
  );
}

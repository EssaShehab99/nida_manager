import 'package:flutter/material.dart';

void snackBarMessage(BuildContext context, String text, Color? color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), backgroundColor: color),
  );
}
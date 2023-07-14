import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String string) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(string),
    ),
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red[900],
      content: Text(error),
    ),
  );
}

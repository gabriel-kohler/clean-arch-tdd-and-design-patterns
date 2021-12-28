import 'package:flutter/material.dart';

mixin KeyboardManager {
  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}

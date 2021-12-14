import 'package:flutter/material.dart';

import '/utils/i18n/i18n.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      child: Text(R.strings.addAccount.toUpperCase()),
    );
  }
}

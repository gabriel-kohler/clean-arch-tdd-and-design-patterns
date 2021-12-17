import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/ui/pages/pages.dart';

import '/utils/i18n/i18n.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signUpPresenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<bool>(
      stream: signUpPresenter.isFormValidStream,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: snapshot.data == true
                ? signUpPresenter.signUp
                : null,
          child: Text(R.strings.addAccount.toUpperCase()),
        );
      }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/ui/helpers/errors/errors.dart';
import '/ui/pages/pages.dart';

import '/utils/i18n/i18n.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signUpPresenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError>(
      stream: signUpPresenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.password,
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          obscureText: true,
          onChanged: signUpPresenter.validatePassword,
        );
      }
    );
  }
}

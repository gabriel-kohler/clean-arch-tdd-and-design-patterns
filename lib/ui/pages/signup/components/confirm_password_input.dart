import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/ui/pages/pages.dart';
import '/ui/helpers/errors/errors.dart';

import '/ui/helpers/helpers.dart';

class ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signUpPresenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: signUpPresenter.confirmPasswordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.confirmPassword,
            errorText: snapshot.hasData ? snapshot.data?.description : null,
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          obscureText: true,
          onChanged: signUpPresenter.validateConfirmPassword,
        );
      }
    );
  }
}

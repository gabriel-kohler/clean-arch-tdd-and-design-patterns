import 'package:flutter/material.dart';
import 'package:practice/ui/helpers/errors/errors.dart';

import 'package:provider/provider.dart';

import '/ui/pages/pages.dart';

class PasswordInput extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    final loginPresenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError>(
        stream: loginPresenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: 'Senha',
              errorText: snapshot.hasData ? snapshot.data.description : null,
              icon: Icon(
                Icons.lock,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            obscureText: true,
            onChanged: loginPresenter.validatePassword,
          );
        });
  }
}
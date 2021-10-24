import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/ui/pages/pages.dart';

class PasswordInput extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    final loginPresenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<String>(
        stream: loginPresenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: 'Senha',
              errorText: snapshot.data?.isEmpty == true
                  ? null
                  : snapshot.data,
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
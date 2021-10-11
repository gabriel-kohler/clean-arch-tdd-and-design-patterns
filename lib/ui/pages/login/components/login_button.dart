import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/ui/pages/pages.dart';

class LoginButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final loginPresenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<bool>(
        stream: loginPresenter.isFormValidStream,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: snapshot.data == true
                ? loginPresenter.auth
                : null,
            child: Text('Entrar'.toUpperCase()),
          );
        });
  }
}
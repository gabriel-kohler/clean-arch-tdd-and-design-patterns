import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/ui/helpers/errors/errors.dart';
import '/ui/pages/pages.dart';


class EmailInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final loginPresenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: loginPresenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: snapshot.hasData ? snapshot.data?.description : null,
            icon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: loginPresenter.validateEmail,
        );
      },
    );
  }
}

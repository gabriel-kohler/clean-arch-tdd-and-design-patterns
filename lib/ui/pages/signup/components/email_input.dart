import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/ui/pages/pages.dart';
import '/ui/helpers/errors/errors.dart';

import '/ui/helpers/helpers.dart';

class EmailInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final signUpPresenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: signUpPresenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
              decoration: InputDecoration(
                labelText: R.strings.email,
                errorText: snapshot.hasData ? snapshot.data?.description : null,
                icon: Icon(
                  Icons.email,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: signUpPresenter.validateEmail,
            );
      }
    );
  }
}

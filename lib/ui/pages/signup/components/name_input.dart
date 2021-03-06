import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/ui/pages/pages.dart';

import '/ui/helpers/helpers.dart';

class NameInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final signUpPresenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: signUpPresenter.nameErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
              decoration: InputDecoration(
                labelText: R.strings.name,
                errorText: snapshot.hasData ? snapshot.data?.description : null,
                icon: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              keyboardType: TextInputType.name,
              onChanged: signUpPresenter.validateName,
            );
      }
    );
  }
}

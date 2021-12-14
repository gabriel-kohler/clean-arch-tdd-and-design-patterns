import 'package:flutter/material.dart';
import 'package:practice/utils/i18n/i18n.dart';

class EmailInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.email,
            icon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        );
  }
}

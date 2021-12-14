import 'package:flutter/material.dart';
import 'package:practice/utils/i18n/i18n.dart';

class NameInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.name,
            icon: Icon(
              Icons.person,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          keyboardType: TextInputType.name,
        );
  }
}

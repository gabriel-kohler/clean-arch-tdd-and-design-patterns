import 'package:flutter/material.dart';

import '/utils/i18n/resources.dart';

import '/ui/pages/signup/components/components.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //LoginHeader(),
            //Headline1(text: R.strings.addAccount),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                child: Column(
                  children: [
                    NameInput(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: EmailInput(),
                    ),
                    PasswordInput(),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        bottom: 32,
                      ),
                      child: ConfirmPasswordInput(),
                    ),
                    SignUpButton(),
                    TextButton.icon(
                      onPressed: () {},
                      label: Text(R.strings.login),
                      icon: Icon(Icons.exit_to_app),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

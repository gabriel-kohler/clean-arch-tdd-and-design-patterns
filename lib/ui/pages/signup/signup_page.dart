import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/ui/helpers/helpers.dart';
import '/ui/components/components.dart';
import '/ui/mixins/mixins.dart';
import '/ui/pages/pages.dart';

import 'components/components.dart';

class SignUpPage extends StatelessWidget with 
KeyboardManager, 
LoadingManager, 
UIMainErrorManager,
NavigationManager {

  final SignUpPresenter signUpPresenter;

  SignUpPage({required this.signUpPresenter});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Builder(
        builder: (context) {
        handleLoading(signUpPresenter.isLoadingStream, context);
        handleMainError(signUpPresenter.mainErrorStream, context);
        handleNavigation(signUpPresenter.navigateToStream, clearNavigation: true);
        return GestureDetector(
          onTap: () => hideKeyboard(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget> [
                LoginHeader(),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Provider(
                    create: (_) => signUpPresenter,
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
                            key: ValueKey('goToLoginPage'),
                            onPressed: signUpPresenter.goToLogin,
                            label: Text(R.strings.login),
                            icon: Icon(Icons.exit_to_app),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

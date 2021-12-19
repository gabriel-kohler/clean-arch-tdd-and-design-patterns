import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '/utils/i18n/resources.dart';

import '/ui/helpers/helpers.dart';
import '../../components/components.dart';
import '/ui/pages/pages.dart';
import './components/components.dart';

class SignUpPage extends StatelessWidget {
  final SignUpPresenter signUpPresenter;

  SignUpPage({@required this.signUpPresenter});

  @override
  Widget build(BuildContext context) {

    void _hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
    }

    return Scaffold(
      body: Builder(
        builder: (context) {
        signUpPresenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });
        signUpPresenter.mainErrorStream.listen((UIError mainError) {
          if (mainError != null) {
            showErrorMessage(context, mainError.description);
          }
        });
        signUpPresenter.navigateToStream.listen((page) {
          if (page?.isNotEmpty == true) {
            Get.offAllNamed(page);
          }
        });
        return GestureDetector(
          onTap: _hideKeyboard,
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
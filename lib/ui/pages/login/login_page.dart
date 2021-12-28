import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


import '/ui/helpers/helpers.dart';
import '/ui/mixins/mixins.dart';
import '/ui/pages/login/components/components.dart';
import '/ui/components/components.dart';
import '/ui/pages/pages.dart';

class LoginPage extends StatelessWidget with 
KeyboardManager, 
LoadingManager, 
UIMainErrorManager,
NavigationManager {

  final LoginPresenter loginPresenter;

  const LoginPage(this.loginPresenter);

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        handleLoading(loginPresenter.isLoadingStream, context);
        handleMainError(loginPresenter.mainErrorStream, context);
        handleNavigation(navigateToStream: loginPresenter.navigateToStream, clearNavigation: true);
        return GestureDetector(
          onTap: () => hideKeyboard(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                Headline1(text: 'login'),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Provider(
                    create: (_) => loginPresenter,
                    child: Form(
                      child: Column(
                        children: [
                          EmailInput(),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 8.0,
                              bottom: 32,
                            ),
                            child: PasswordInput(),
                          ),
                          LoginButton(),
                          TextButton.icon(
                            key: ValueKey('goToSignUpButton'),
                            onPressed: loginPresenter.goToSignUp,
                            icon: Icon(Icons.person),
                            label: Text(R.strings.addAccount), //Text('Adicionar Conta')
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

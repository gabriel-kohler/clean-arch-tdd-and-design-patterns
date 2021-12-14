import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practice/utils/i18n/resources.dart';

import 'package:provider/provider.dart';

import '/ui/pages/login/components/components.dart';
import '/ui/components/components.dart';
import '/ui/pages/pages.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter loginPresenter;

  const LoginPage(this.loginPresenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        loginPresenter.isLoadingStream.listen(
          (isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          },
        );
        loginPresenter.mainErrorStream.listen((mainError) {
          if (mainError != null) {
            showErrorMessage(context, mainError);
          }
        });
        loginPresenter.navigateToStream.listen((page) {
          if (page?.isNotEmpty == true) {
            Get.offAllNamed(page);
          }
        });
        return SingleChildScrollView(
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
                          onPressed: () {},
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
        );
      }),
    );
  }
}

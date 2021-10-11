import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/ui/pages/login/components/components.dart';
import '/ui/components/components.dart';
import '/ui/pages/pages.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter loginPresenter;

  const LoginPage(this.loginPresenter);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.loginPresenter.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.loginPresenter.isLoadingStream.listen(
          (isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          },
        );
        widget.loginPresenter.mainErrorStream.listen((mainError) {
          if (mainError != null) {
            showErrorMessage(context, mainError);
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
                  create: (_) => widget.loginPresenter,
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
                        StreamBuilder<bool>(
                            stream: widget.loginPresenter.isFormValidStream,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                onPressed: snapshot.data == true
                                    ? widget.loginPresenter.auth
                                    : null,
                                child: Text('Entrar'.toUpperCase()),
                              );
                            }),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.person),
                          label: Text('Criar conta'),
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
import 'package:flutter/material.dart';

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
          if (mainError.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red[900],
                content: Text('login error'),
              ),
            );
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
                child: Form(
                  child: Column(
                    children: [
                      StreamBuilder<String>(
                        stream: widget.loginPresenter.emailErrorStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              errorText: snapshot.data?.isEmpty == true
                                  ? null
                                  : snapshot.data,
                              icon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: widget.loginPresenter.validateEmail,
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8.0,
                          bottom: 32,
                        ),
                        child: StreamBuilder<String>(
                            stream: widget.loginPresenter.passsowrdErrorStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  errorText: snapshot.data?.isEmpty == true
                                      ? null
                                      : snapshot.data,
                                  icon: Icon(
                                    Icons.lock,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                                obscureText: true,
                                onChanged: widget.loginPresenter.validatePassword,
                              );
                            }),
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
            ],
          ),
        );
      }),
    );
  }
}

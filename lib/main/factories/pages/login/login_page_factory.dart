import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:practice/data/usecases/remote_authentication.dart';
import 'package:practice/infra/http/http_adapter.dart';
import 'package:practice/validation/validators/validators.dart';

import '/ui/pages/pages.dart';

import '/presentation/presenters/presenters.dart';

Widget makeLoginPage() {
  final client = Client();
  final httpAdapter = HttpAdapter(client);
  final url = 'http://fordevs.herokuapp.com/api/login';
  final remoteAuthentication = RemoteAuthentication(
    httpClient: httpAdapter,
    url: url,
  );
  final validationComposite = ValidationComposite([
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password'),
  ]);
  final loginPresenter = StreamLoginPresenter(
    validation: validationComposite,
    authentication: remoteAuthentication,
  );
  return LoginPage(loginPresenter);
}

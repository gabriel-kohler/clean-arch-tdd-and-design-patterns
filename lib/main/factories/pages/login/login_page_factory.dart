import 'package:flutter/material.dart';

import '/main/factories/pages/login/login.dart';
import '/presentation/presenters/presenters.dart';
import '/ui/pages/pages.dart';


import '../../factories.dart';


Widget makeLoginPage() {
  
  
  
  final loginPresenter = StreamLoginPresenter(
    validation: makeValidationComposite(),
    authentication: makeRemoteAuthentication(),
  );
  return LoginPage(loginPresenter);
}

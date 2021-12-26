import 'package:flutter/material.dart';

import '/main/factories/pages/login/login.dart';

import '/ui/pages/pages.dart';

Widget makeLoginPage() {
  return LoginPage(makeGetxLoginPresenter());
}

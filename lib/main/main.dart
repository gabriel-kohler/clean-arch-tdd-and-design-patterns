import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:practice/main/factories/pages/login/login_page_factory.dart';
import 'package:practice/utils/app_routes.dart';

import '/ui/components/components.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final ThemeData theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: AppRoute.SplashPage,
      getPages: [
        GetPage(name: AppRoute.SplashPage, page: makeLoginPage),
      ],
    );
  }
}
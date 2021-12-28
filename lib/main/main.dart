import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '/utils/app_routes.dart';

import '/ui/components/components.dart';
import 'factories/factories.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
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
      initialRoute: '/survey_result/3',
      getPages: [
        GetPage(name: AppRoute.SplashPage, page: makeSplashPage),
        GetPage(name: AppRoute.LoginPage, page: makeLoginPage),
        GetPage(name: AppRoute.SignUpPage, page: makeSignUpPage),
        GetPage(name: AppRoute.SurveysPage, page: makeSurveysPage),
        GetPage(name: '${AppRoute.SurveyResultPage}/:surveyId', page: makeSurveyResultPage),
      ],
    );
  }
}

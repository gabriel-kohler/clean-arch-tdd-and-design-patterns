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

    final routeObserver =  Get.put<RouteObserver>(RouteObserver<PageRoute>());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      navigatorObservers: [routeObserver],
      initialRoute: AppRoute.SplashPage,
      getPages: makePages(),
    );
  }
}

List<GetPage> makePages() => [
      GetPage(name: AppRoute.SplashPage, page: makeSplashPage),
      GetPage(name: AppRoute.LoginPage, page: makeLoginPage),
      GetPage(name: AppRoute.SignUpPage, page: makeSignUpPage),
      GetPage(name: AppRoute.SurveysPage, page: makeSurveysPage),
      GetPage(
        name: '${AppRoute.SurveyResultPage}/:survey_id',
        page: makeSurveyResultPage,
      ),
    ];

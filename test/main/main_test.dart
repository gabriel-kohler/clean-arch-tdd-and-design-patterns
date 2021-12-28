import 'package:test/test.dart';

import 'package:practice/utils/app_routes.dart';
import 'package:practice/main/main.dart';

void main() {
  test('Should create correct route pages in main', () {
    final pages = makePages();
    final pageNames = pages.map((page) => page.name).toList();

    expect(pageNames, [
      AppRoute.SplashPage,
      AppRoute.LoginPage,
      AppRoute.SignUpPage,
      AppRoute.SurveysPage,
      '${AppRoute.SurveyResultPage}/:survey_id',
    ]);
  });
}
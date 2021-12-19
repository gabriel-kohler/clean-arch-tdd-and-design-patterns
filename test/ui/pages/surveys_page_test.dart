import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mockito/mockito.dart';

import 'package:practice/ui/pages/pages.dart';
import 'package:practice/utils/app_routes.dart';
import 'package:practice/utils/utils.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {

  SurveysPresenter surveysPresenterSpy;

  Future<void> loadPage(WidgetTester tester) async {

    surveysPresenterSpy = SurveysPresenterSpy();

    final surveysPage = GetMaterialApp(
      initialRoute: AppRoute.SurveysPage,
      getPages: [
        GetPage(name: AppRoute.SurveysPage, page: () => SurveysPage(surveysPresenter: surveysPresenterSpy)),
      ],
    );

    await tester.pumpWidget(surveysPage);
  }

  testWidgets('Should SurveysPage call loadData on page loading', (WidgetTester tester) async {

    await loadPage(tester);

    verify(surveysPresenterSpy.loadData()).called(1);

  });
}
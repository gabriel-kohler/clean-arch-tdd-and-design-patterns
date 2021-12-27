import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:practice/ui/pages/pages.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {

  SurveyResultPresenter surveyResultPresenterSpy;

  Future<void> loadPage(WidgetTester tester) async {

    surveyResultPresenterSpy = SurveyResultPresenterSpy();

    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/:any_survey_id',
      getPages: [
        GetPage(name: '/survey_result/:survey_id', page: () => SurveyResultPage(surveyResultPresenter: surveyResultPresenterSpy)),
      ],
    );

    mockNetworkImagesFor(() async {
      await tester.pumpWidget(surveysPage);
    });
  }

  testWidgets('Should call LoadSurveyResult on page load', (WidgetTester tester) async {

    await loadPage(tester);

    verify(surveyResultPresenterSpy.loadData()).called(1);

  });

}
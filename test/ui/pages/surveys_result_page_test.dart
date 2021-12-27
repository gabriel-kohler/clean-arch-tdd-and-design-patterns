import 'package:get/get_navigation/get_navigation.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:mockito/mockito.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:practice/ui/helpers/helpers.dart';
import 'package:practice/ui/pages/pages.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {

  SurveyResultPresenter surveyResultPresenterSpy;

  StreamController<bool> isLoadingController;
  StreamController<dynamic> surveyResultController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    surveyResultController = StreamController<dynamic>();
  }

  void mockStreams() {
    when(surveyResultPresenterSpy.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(surveyResultPresenterSpy.surveyResultStream).thenAnswer((_) => surveyResultController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    surveyResultController.close();  
  }

  Future<void> loadPage(WidgetTester tester) async {

    surveyResultPresenterSpy = SurveyResultPresenterSpy();

    initStreams();
    mockStreams();

    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/:any_survey_id',
      getPages: [
        GetPage(name: '/survey_result/:survey_id', page: () => SurveyResultPage(surveyResultPresenter: surveyResultPresenterSpy)),
      ],
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(surveysPage);
    });
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should call LoadSurveyResult on page load', (WidgetTester tester) async {

    await loadPage(tester);

    verify(surveyResultPresenterSpy.loadData()).called(1);

  });
  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should present error if surveyResultStream is empty', (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Ocorreu um erro. Tente novamente em breve'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);

  });

}
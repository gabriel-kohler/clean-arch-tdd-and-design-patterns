import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/ui/helpers/errors/errors.dart';

import 'package:practice/ui/pages/pages.dart';
import 'package:practice/utils/app_routes.dart';
import 'package:practice/utils/utils.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {

  SurveysPresenter surveysPresenterSpy;

  StreamController<List<SurveyViewModel>> surveysController;
  StreamController<String> navigateToController;

  Future<void> loadPage(WidgetTester tester) async {

    surveysController = StreamController<List<SurveyViewModel>>();
    navigateToController = StreamController<String>();

    surveysPresenterSpy = SurveysPresenterSpy();

    when(surveysPresenterSpy.surveysStream).thenAnswer((_) => surveysController.stream);
    when(surveysPresenterSpy.navigateToStream).thenAnswer((_) => navigateToController.stream);


    final surveysPage = GetMaterialApp(
      initialRoute: AppRoute.SurveysPage,
      getPages: [
        GetPage(name: AppRoute.SurveysPage, page: () => SurveysPage(surveysPresenter: surveysPresenterSpy)),
        GetPage(name: '/any_route', page: () => Scaffold(
          body: Text('navigation test'),
        )),
      ],
    );

    await tester.pumpWidget(surveysPage);
  }

  tearDown(() {
    surveysController.close();
    navigateToController.close();
  });

  List<SurveyViewModel> makeSurveys() => [
    SurveyViewModel(id: '1', question: 'Question 1', date: 'Date1', didAnswer: true),
    SurveyViewModel(id: '2', question: 'Question 2', date: 'Date2', didAnswer: false),
  ];

  testWidgets('Should SurveysPage call loadData on page loading', (WidgetTester tester) async {

    await loadPage(tester);

    verify(surveysPresenterSpy.loadData()).called(1);

  });

  testWidgets('Should present error if surveysStream fails', (WidgetTester tester) async {

    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Ocorreu um erro. Tente novamente em breve'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);

  });

  testWidgets('Should present data if surveysStream success', (WidgetTester tester) async {

    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    surveysController.add(makeSurveys());
    await tester.pump();

    expect(find.text('Ocorreu um erro. Tente novamente em breve'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);

    expect(find.text('Date1'), findsWidgets);
    expect(find.text('Date2'), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);

  });

  testWidgets('Should SurveysPage call loadData on reload button click', (WidgetTester tester) async {

    await loadPage(tester);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();

    await tester.tap(find.text('Recarregar'));

    verify(surveysPresenterSpy.loadData()).called(2);

  });

  testWidgets('Should call goToSurveyResult on survey click', (WidgetTester tester) async {

    await loadPage(tester);

    surveysController.add(makeSurveys());
    await tester.pump();

    await tester.tap(find.text('Question 1'));
    await tester.pump();
  
    verify(surveysPresenterSpy.goToSurveyResult('1')).called(1);

  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
    expect(find.text('navigation test'), findsOneWidget);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, AppRoute.SurveysPage);

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, AppRoute.SurveysPage);
  });



}
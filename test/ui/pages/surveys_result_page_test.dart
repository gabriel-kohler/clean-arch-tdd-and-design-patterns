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

  StreamController<SurveyResultViewModel> surveyResultController;

  void initStreams() {
    surveyResultController = StreamController<SurveyResultViewModel>();
  }

  void mockStreams() {
    when(surveyResultPresenterSpy.surveyResultStream).thenAnswer((_) => surveyResultController.stream);
  }

  void closeStreams() {
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


  SurveyResultViewModel makeSurveyResult() => SurveyResultViewModel(surveyId: 'any_id', question: 'Question', answers: [
    SurveyAnswerViewModel(image: 'Image 0', answer: 'Answer 0', isCurrentAnswer: true, percent: '60%'),
    SurveyAnswerViewModel(answer: 'Answer 1', isCurrentAnswer: false, percent: '40%'),
  ]);

  testWidgets('Should call LoadSurveyResult on page load', (WidgetTester tester) async {

    await loadPage(tester);

    verify(surveyResultPresenterSpy.loadData()).called(1);

  });

  testWidgets('Should present error if surveyResultStream fails', (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Ocorreu um erro. Tente novamente em breve'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question'), findsNothing);

    expect(find.byType(CircularProgressIndicator), findsNothing);

  });

  testWidgets('Should SurveyResultPage call loadData on reload button click', (WidgetTester tester) async {
    await loadPage(tester);
    
    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();

    await tester.tap(find.text('Recarregar'));

    verify(surveyResultPresenterSpy.loadData()).called(2);

  });

  testWidgets('Should present valid data if surveyResultStream', (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    surveyResultController.add(makeSurveyResult());

    await mockNetworkImagesFor(() async {
      await tester.pump();
    });
    

    expect(find.text('Ocorreu um erro. Tente novamente em breve'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question'), findsOneWidget);
    expect(find.text('Answer 0'), findsOneWidget);
    expect(find.text('Answer 1'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(find.byType(ActiveIcon), findsOneWidget);
    expect(find.byType(DisableIcon), findsOneWidget);

    final image = tester.widget<Image>(find.byKey(ValueKey('imageUrl'))).image as NetworkImage;

    expect(image.url, 'Image 0');

    expect(find.byType(CircularProgressIndicator), findsNothing);

  });

}
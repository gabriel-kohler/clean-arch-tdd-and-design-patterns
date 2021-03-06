import 'package:network_image_mock/network_image_mock.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:practice/ui/helpers/helpers.dart';
import 'package:practice/ui/pages/pages.dart';
import 'package:practice/utils/utils.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {

  late SurveyResultPresenterSpy surveyResultPresenterSpy;

  Future<void> loadPage(WidgetTester tester) async {

    surveyResultPresenterSpy = SurveyResultPresenterSpy();

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        makePage(
          initialRoute: '/survey_result/:any_survey_id', 
          page: () => SurveyResultPage(surveyResultPresenterSpy),
        ),
      );
    });

  }

  tearDown(() {

  });

  testWidgets('Should call LoadSurveyResult on page load', (WidgetTester tester) async {

    await loadPage(tester);

    verify(() => (surveyResultPresenterSpy.loadData())).called(1);

  });

  testWidgets('Should present error if surveyResultStream fails', (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    surveyResultPresenterSpy.emitSurveyResultError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Ocorreu um erro. Tente novamente em breve'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question'), findsNothing);

    expect(find.byType(CircularProgressIndicator), findsNothing);

  });

  testWidgets('Should SurveyResultPage call loadData on reload button click', (WidgetTester tester) async {
    await loadPage(tester);
    
    surveyResultPresenterSpy.emitSurveyResultError(UIError.unexpected.description);
    await tester.pump();

    await tester.tap(find.text('Recarregar'));

    verify(() => (surveyResultPresenterSpy.loadData())).called(2);

  });

  testWidgets('Should present valid data if surveyResultStream', (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    surveyResultPresenterSpy.emitSurveyResultValid();
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

  testWidgets('Should logout', (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultPresenterSpy.emitSessionExpired(true);
    await tester.pumpAndSettle();

    expect(currentRoute, AppRoute.LoginPage);
    expect(find.text('fake login'), findsOneWidget);
  });

  testWidgets('Should not logout', (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultPresenterSpy.emitSessionExpired(false);
    await tester.pump();
    expect(currentRoute, '${AppRoute.SurveyResultPage}/:any_survey_id');
  });

  testWidgets('Should SurveyResultPage call save on item list click', (WidgetTester tester) async {
    await loadPage(tester);
    
    surveyResultPresenterSpy.emitSurveyResultValid();

    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    await tester.tap(find.text('Answer 1'));

    verify(() => (surveyResultPresenterSpy.save(answer: 'Answer 1'))).called(1);

  });

  testWidgets('Should SurveyResultPage not call on current answer click', (WidgetTester tester) async {
    await loadPage(tester);
    
    surveyResultPresenterSpy.emitSurveyResultValid();

    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    await tester.tap(find.text('Answer 0'));

    verifyNever(() => surveyResultPresenterSpy.save(answer: 'Answer 0'));

  });

}
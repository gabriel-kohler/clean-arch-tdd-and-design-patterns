import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:practice/ui/pages/pages.dart';
import 'package:practice/utils/app_routes.dart';

import '../helpers/helpers.dart';


class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {

  late SplashPresenter splashPresenterSpy;
  
  late StreamController<String> navigationToController;

  Future<void> loadPage(WidgetTester tester) async {

    splashPresenterSpy = SplashPresenterSpy();

    navigationToController = StreamController<String>();

    when(() => (splashPresenterSpy.navigateToStream)).thenAnswer((_) => navigationToController.stream);

    await tester.pumpWidget(
      makePage(
        initialRoute: AppRoute.SplashPage, 
        page: () => SplashPage(splashPresenter: splashPresenterSpy),
      ),
    );

  }

  tearDown(() {
    navigationToController.close();
  });

  testWidgets('Should SplashPage start with correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('Should SplashPage call CheckAccount', (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => (splashPresenterSpy.checkAccount())).called(1);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigationToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigationToController.add('');
    await tester.pump();

    expect(currentRoute, AppRoute.SplashPage);

  });

}

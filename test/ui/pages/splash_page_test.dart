import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:practice/ui/pages/pages.dart';
import 'package:practice/utils/app_routes.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {

  late SplashPresenterSpy splashPresenterSpy;
  
  Future<void> loadPage(WidgetTester tester) async {

    splashPresenterSpy = SplashPresenterSpy();

    await tester.pumpWidget(
      makePage(
        initialRoute: AppRoute.SplashPage, 
        page: () => SplashPage(splashPresenter: splashPresenterSpy),
      ),
    );

  }

  tearDown(() {
    splashPresenterSpy.dispose();
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

    splashPresenterSpy.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    splashPresenterSpy.emitNavigateTo('');
    await tester.pump();

    expect(currentRoute, AppRoute.SplashPage);

  });

}

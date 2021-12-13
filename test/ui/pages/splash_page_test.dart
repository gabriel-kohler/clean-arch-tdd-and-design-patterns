import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/utils/app_routes.dart';

abstract class SplashPresenter {

  Stream<String> get navigateToStream;

  Future<void> checkAccount();
}

class SplashPage extends StatelessWidget {

  final SplashPresenter splashPresenter;

  SplashPage({@required this.splashPresenter});

  @override
  Widget build(BuildContext context) {
    splashPresenter.checkAccount();
    return Scaffold(
      body: Builder(
        builder: (context) {
          splashPresenter.navigateToStream.listen((page) {
            if (page?.isNotEmpty == true) {
              Get.offAllNamed(page);
            }
          });
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      ),
    );
  }
}

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {

  SplashPresenter splashPresenterSpy;
  
  StreamController<String> navigationToController;

  Future<void> loadPage(WidgetTester tester) async {

    splashPresenterSpy = SplashPresenterSpy();

    navigationToController = StreamController<String>();

    when(splashPresenterSpy.navigateToStream).thenAnswer((_) => navigationToController.stream);

    final splashPage = GetMaterialApp(
      initialRoute: AppRoute.SplashPage,
      getPages: [
        GetPage(name: AppRoute.SplashPage, page: () => SplashPage(splashPresenter: splashPresenterSpy)),
        GetPage(name: '/any_route', page: () => Scaffold(
          body: Text('navigation test'),
          ),
        ),
      ],
    );
    await tester.pumpWidget(splashPage);
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

    verify(splashPresenterSpy.checkAccount()).called(1);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigationToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigationToController.add('');
    await tester.pump();

    expect(Get.currentRoute, AppRoute.SplashPage);

    navigationToController.add(null);
    await tester.pump();

    expect(Get.currentRoute, AppRoute.SplashPage);
  });

}

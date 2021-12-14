import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/ui/pages/login/login_page.dart';
import 'package:practice/ui/pages/pages.dart';
import 'package:practice/utils/app_routes.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter loginPresenter;
  StreamController<String> emailErrorController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;
  StreamController<String> passwordErrorController;
  StreamController<String> mainErrorController;
  StreamController<String> navigateToController;
  
  void initStreams() {
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    mainErrorController = StreamController<String>();
    navigateToController = StreamController<String>();
  }

  void mockStreams() {
    when(loginPresenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);    
    when(loginPresenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);    
    when(loginPresenter.isFormValidStream).thenAnswer((_) => isFormValidController.stream);    
    when(loginPresenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);    
    when(loginPresenter.mainErrorStream).thenAnswer((_) => mainErrorController.stream);
    when(loginPresenter.navigateToStream).thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {

    loginPresenter = LoginPresenterSpy();

    initStreams();
    mockStreams();
    
    final loginPage = GetMaterialApp(
      initialRoute: AppRoute.LoginPage,
      getPages: [
        GetPage(name: AppRoute.LoginPage, page: () => LoginPage(loginPresenter)),
        GetPage(name: '/any_route', page: () => Scaffold(
          body: Text('navigation test')),
        ),
      ],
    );

    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should load with correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

    //emailTextChildren = captura os filhos do tipo text do componente que contem uma String com valor "Email"
    //por padrão um textformfield sempre vai ter um filho do tipo text, que é o labelText, se ele tiver mais um é porque
    //o segundo filho do tipo text corresponde ao errorText, ou seja, ele tem um erro
    // seguindo a lógica, se o textformfield tem mais de um filho do tipo text, é porque ele tem um erro
    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );

    expect(emailTextChildren, findsOneWidget);

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );

    expect(passwordTextChildren, findsOneWidget);

    final elevatedButtonLogin = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton),
    );

    expect(elevatedButtonLogin.onPressed, null);

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    final password = faker.internet.password();

    await tester.enterText(find.bySemanticsLabel('Email'), email);

    verify(loginPresenter.validateEmail(email));

    await tester.enterText(find.bySemanticsLabel('Senha'), password);

    verify(loginPresenter.validatePassword(password));
  });

  testWidgets('Should present error if email is invalid', (WidgetTester tester) async {

    await loadPage(tester);

    emailErrorController.add("any error");

    await tester.pump();
    
    expect(find.text('any error'), findsOneWidget);

  });

  testWidgets('Should present no error if email is valid', (WidgetTester tester) async {

    await loadPage(tester);

    emailErrorController.add(null);

    await tester.pump();

    final emailTextChildren = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

    expect(emailTextChildren, findsOneWidget);

  });

  testWidgets('Should present no error if email is valid', (WidgetTester tester) async {

    await loadPage(tester);

    emailErrorController.add('');

    await tester.pump();

    final emailTextChildren = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

    expect(emailTextChildren, findsOneWidget);

  });

  testWidgets('Should present no error if password is invalid', (WidgetTester tester) async {

    await loadPage(tester);

    passwordErrorController.add(null);

    await tester.pump();

    final passwordTextChildren = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    
    expect(passwordTextChildren, findsOneWidget);

  });
   
  testWidgets('Should enable button if form is valid', (WidgetTester tester) async {

    await loadPage(tester);

    isFormValidController.add(true);

    await tester.pump();

    final loginButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(loginButton.onPressed, isNotNull);

  }); 

  testWidgets('Should enable disable if form is valid', (WidgetTester tester) async {

    await loadPage(tester);

    isFormValidController.add(false);

    await tester.pump();

    final loginButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(loginButton.onPressed, null);

  });

  testWidgets('Should call authentication on form submit', (WidgetTester tester) async {

    await loadPage(tester);

    isFormValidController.add(true);

    await tester.pump();
  
    final loginButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
  
    loginButton.onPressed();

    expect(loginButton.onPressed, isNotNull);

    await tester.pump();
  
    verify(loginPresenter.auth()).called(1);

  });

  testWidgets('Should present loading', (WidgetTester tester) async {

    await loadPage(tester);

    isLoadingController.add(true);

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

  });

  testWidgets('Should hide loading', (WidgetTester tester) async {

    await loadPage(tester);

    isLoadingController.add(true);

    await tester.pump();

    isLoadingController.add(false);

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);

  });

  testWidgets('Should present error message if authentication fails', (WidgetTester tester) async { 
    
    await loadPage(tester);
    
    mainErrorController.add('login error');
    
    await tester.pump();

    expect(find.text('login error'), findsOneWidget);

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
    await tester.pumpAndSettle();

    expect(Get.currentRoute, AppRoute.LoginPage);

    navigateToController.add('');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, AppRoute.LoginPage);
  });

}

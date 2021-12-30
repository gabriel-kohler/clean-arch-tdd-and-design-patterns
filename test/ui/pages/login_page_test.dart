import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:practice/utils/utils.dart';

import 'package:practice/ui/helpers/errors/errors.dart';
import 'package:practice/ui/pages/login/login_page.dart';
import 'package:practice/ui/pages/pages.dart';

import '../helpers/helpers.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter loginPresenter;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> mainErrorController;
  StreamController<String> navigateToController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;
  
  void initStreams() {
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    mainErrorController = StreamController<UIError>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
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
    
    await tester.pumpWidget(
      makePage(
        initialRoute: AppRoute.LoginPage, 
        page: () => LoginPage(loginPresenter),
      ),
    );

  }

  tearDown(() {
    closeStreams();
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

    emailErrorController.add(UIError.invalidField);

    await tester.pump();
    
    expect(find.text('Campo inválido'), findsOneWidget);

  });

  testWidgets('Should present error if email is empty', (WidgetTester tester) async {

    await loadPage(tester);

    emailErrorController.add(UIError.requiredField);

    await tester.pump();
    
    expect(find.text('Campo obrigatório'), findsOneWidget);

  });

  testWidgets('Should present no error if email is valid', (WidgetTester tester) async {

    await loadPage(tester);

    emailErrorController.add(null);

    await tester.pump();

    final emailTextChildren = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

    expect(emailTextChildren, findsOneWidget);

  });

  testWidgets('Should present no error if password is invalid', (WidgetTester tester) async {

    await loadPage(tester);

    passwordErrorController.add(null);

    await tester.pump();

    final passwordTextChildren = find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    
    expect(passwordTextChildren, findsOneWidget);

  });

  testWidgets('Should present error if password is empty', (WidgetTester tester) async {

    await loadPage(tester);

    passwordErrorController.add(UIError.requiredField);

    await tester.pump();
    
    expect(find.text('Campo obrigatório'), findsOneWidget);

  });
   
  testWidgets('Should enable button if form is valid', (WidgetTester tester) async {

    await loadPage(tester);

    isFormValidController.add(true);

    await tester.pump();

    final loginButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(loginButton.onPressed, isNotNull);

  }); 

  testWidgets('Should enable disable if form is invalid', (WidgetTester tester) async {

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

    isLoadingController.add(null);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

  });

  testWidgets('Should present error message if authentication fails', (WidgetTester tester) async { 
    
    await loadPage(tester);
    
    mainErrorController.add(UIError.invalidCredentials);
    
    await tester.pump();

    expect(find.text('Credenciais inválidas'), findsOneWidget);

  });

  testWidgets('Should present error message if authentication throws', (WidgetTester tester) async { 
    
    await loadPage(tester);
    
    mainErrorController.add(UIError.unexpected);
    
    await tester.pump();

    expect(find.text('Ocorreu um erro. Tente novamente em breve'), findsOneWidget);

  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
    expect(find.text('navigation test'), findsOneWidget);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pumpAndSettle();

    expect(currentRoute, AppRoute.LoginPage);

    navigateToController.add('');
    await tester.pumpAndSettle();

    expect(currentRoute, AppRoute.LoginPage);
  });

  testWidgets('Should call goToSignUp on link click', (WidgetTester tester) async {

    await loadPage(tester);

    final goToSignUpButton = tester.widget<TextButton>(find.byKey(ValueKey('goToSignUpButton')));
  
    goToSignUpButton.onPressed();

    expect(goToSignUpButton.onPressed, isNotNull);

    await tester.pump();
  
    verify(loginPresenter.goToSignUp()).called(1);

  });

}

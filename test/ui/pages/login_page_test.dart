
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:practice/utils/utils.dart';

import 'package:practice/ui/helpers/errors/errors.dart';
import 'package:practice/ui/pages/pages.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {
  late LoginPresenterSpy loginPresenter;

  Future<void> loadPage(WidgetTester tester) async {

    loginPresenter = LoginPresenterSpy();

    await tester.pumpWidget(
      makePage(
        initialRoute: AppRoute.LoginPage, 
        page: () => LoginPage(loginPresenter),
      ),
    );

  }

  tearDown(() {
    loginPresenter.dispose();
  });

  testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    final password = faker.internet.password();

    await tester.enterText(find.bySemanticsLabel('Email'), email);

    verify(() => (loginPresenter.validateEmail(email)));

    await tester.enterText(find.bySemanticsLabel('Senha'), password);

    verify(() => (loginPresenter.validatePassword(password)));
  });

  testWidgets('Should present error if email is invalid', (WidgetTester tester) async {

    await loadPage(tester);

    loginPresenter.emitEmailError(UIError.invalidField);

    await tester.pump();
    
    expect(find.text('Campo inválido'), findsOneWidget);

  });

  testWidgets('Should present error if email is empty', (WidgetTester tester) async {

    await loadPage(tester);

    loginPresenter.emitEmailError(UIError.requiredField);

    await tester.pump();
    
    expect(find.text('Campo obrigatório'), findsOneWidget);

  });

  testWidgets('Should present no error if email is valid', (WidgetTester tester) async {

    await loadPage(tester);

    loginPresenter.emitEmailValid();

    await tester.pump();

    final emailTextChildren = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

    expect(emailTextChildren, findsOneWidget);

  });

  testWidgets('Should present no error if password is valid', (WidgetTester tester) async {

    await loadPage(tester);

    loginPresenter.emitPasswordValid();

    await tester.pump();

    final passwordTextChildren = find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    
    expect(passwordTextChildren, findsOneWidget);

  });

  testWidgets('Should present error if password is empty', (WidgetTester tester) async {

    await loadPage(tester);

    loginPresenter.emitPasswordError(UIError.requiredField);

    await tester.pump();
    
    expect(find.text('Campo obrigatório'), findsOneWidget);

  });
   
  testWidgets('Should enable button if form is valid', (WidgetTester tester) async {

    await loadPage(tester);

    loginPresenter.emitFormValid();

    await tester.pump();

    final loginButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(loginButton.onPressed, isNotNull);

  }); 

  testWidgets('Should enable disable if form is invalid', (WidgetTester tester) async {

    await loadPage(tester);

    loginPresenter.emitFormError();

    await tester.pump();

    final loginButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(loginButton.onPressed, null);

  });

  testWidgets('Should call authentication on form submit', (WidgetTester tester) async {

    await loadPage(tester);

    loginPresenter.emitFormValid();

    await tester.pump();
  
    final loginButton = find.byType(ElevatedButton);
  
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pump();
  
    verify(() => (loginPresenter.auth())).called(1);

  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {

    await loadPage(tester);

    loginPresenter.emitLoading(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    loginPresenter.emitLoading(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    loginPresenter.emitLoading(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

  });

  testWidgets('Should present error message if authentication fails', (WidgetTester tester) async { 
    
    await loadPage(tester);
    
    loginPresenter.emitMainError(UIError.invalidCredentials);
    
    await tester.pump();

    expect(find.text('Credenciais inválidas'), findsOneWidget);

  });

  testWidgets('Should present error message if authentication throws', (WidgetTester tester) async { 
    
    await loadPage(tester);
    
    loginPresenter.emitMainError(UIError.unexpected);
    
    await tester.pump();

    expect(find.text('Ocorreu um erro. Tente novamente em breve'), findsOneWidget);

  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    loginPresenter.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
    expect(find.text('navigation test'), findsOneWidget);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    loginPresenter.emitNavigateTo('');
    await tester.pumpAndSettle();

    expect(currentRoute, AppRoute.LoginPage);

  });

  testWidgets('Should call goToSignUp on link click', (WidgetTester tester) async {

    await loadPage(tester);

    final goToSignUpButton = find.byKey(ValueKey('goToSignUpButton'));
  
    await tester.ensureVisible(goToSignUpButton);
    await tester.tap(goToSignUpButton);
    await tester.pump();
  
    verify(() => (loginPresenter.goToSignUp())).called(1);

  });

}

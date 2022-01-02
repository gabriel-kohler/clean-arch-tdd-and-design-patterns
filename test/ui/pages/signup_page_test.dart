import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice/ui/helpers/errors/errors.dart';

import 'package:practice/ui/pages/signup/signup.dart';

import 'package:practice/utils/app_routes.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {

  late SignUpPresenterSpy signUpPresenterSpy;

  Future<void> loadPage(WidgetTester tester) async {

    signUpPresenterSpy = SignUpPresenterSpy();

    await tester.pumpWidget(
      makePage(
        initialRoute: AppRoute.SignUpPage, 
        page: () => SignUpPage(signUpPresenter: signUpPresenterSpy),
      ),
    );

  }

  tearDown(() {
    signUpPresenterSpy.dispose();
  });

  testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    final email = faker.internet.email();
    final password = faker.internet.password();

    await tester.enterText(find.bySemanticsLabel('Nome'), name);

    verify(() => (signUpPresenterSpy.validateName(name)));

    await tester.enterText(find.bySemanticsLabel('Email'), email);

    verify(() => (signUpPresenterSpy.validateEmail(email)));

    await tester.enterText(find.bySemanticsLabel('Senha'), password);

    verify(() => (signUpPresenterSpy.validatePassword(password)));

    await tester.enterText(find.bySemanticsLabel('Confirmar senha'), password);

    verify(() => (signUpPresenterSpy.validateConfirmPassword(password)));
  });

  testWidgets('Should present error if name is invalid', (WidgetTester tester) async {

    await loadPage(tester);

    signUpPresenterSpy.emitNameError(UIError.invalidField);

    await tester.pump();
    
    expect(find.text('Campo inválido'), findsOneWidget);

  });

  testWidgets('Should present no error if name is valid', (WidgetTester tester) async {

    await loadPage(tester);

    signUpPresenterSpy.emitNameValid();

    await tester.pump();

    final nameTextChildren = find.descendant(of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));

    expect(nameTextChildren, findsOneWidget);

  });

  testWidgets('Should present error if email is invalid', (WidgetTester tester) async {

    await loadPage(tester);

    signUpPresenterSpy.emitEmailError(UIError.invalidField);

    await tester.pump();
    
    expect(find.text('Campo inválido'), findsOneWidget);

  });

  testWidgets('Should present error if email is empty', (WidgetTester tester) async {

    await loadPage(tester);

    signUpPresenterSpy.emitEmailError(UIError.requiredField);

    await tester.pump();
    
    expect(find.text('Campo obrigatório'), findsOneWidget);

  });

  testWidgets('Should present no error if email is valid', (WidgetTester tester) async {

    await loadPage(tester);

    signUpPresenterSpy.emitEmailValid();

    await tester.pump();

    final emailTextChildren = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

    expect(emailTextChildren, findsOneWidget);

  });

  testWidgets('Should present error if password is empty', (WidgetTester tester) async {

    await loadPage(tester);

    signUpPresenterSpy.emitPasswordError(UIError.requiredField);

    await tester.pump();
    
    expect(find.text('Campo obrigatório'), findsOneWidget);

  });

  testWidgets('Should present no error if password is valid', (WidgetTester tester) async {

    await loadPage(tester);

    signUpPresenterSpy.emitPasswordValid();

    await tester.pump();

    final passwordTextChildren = find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    
    expect(passwordTextChildren, findsOneWidget);

  });

  testWidgets('Should present error if confirmPassword is empty', (WidgetTester tester) async {

    await loadPage(tester);

    signUpPresenterSpy.emitConfirmPasswordError(UIError.requiredField);

    await tester.pump();
    
    expect(find.text('Campo obrigatório'), findsOneWidget);

  });

  testWidgets('Should present no error if confirmPassword is valid', (WidgetTester tester) async {

    await loadPage(tester);

    signUpPresenterSpy.emitConfirmPasswordValid();

    await tester.pump();

    final confirmPasswordTextChildren = find.descendant(of: find.bySemanticsLabel('Confirmar senha'), matching: find.byType(Text));
    
    expect(confirmPasswordTextChildren, findsOneWidget);

  });

  testWidgets('Should enable button if form is valid', (WidgetTester tester) async {

    await loadPage(tester);

    signUpPresenterSpy.emitFormValid();

    await tester.pump();

    final createAccountButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(createAccountButton.onPressed, isNotNull);

  }); 

  testWidgets('Should enable disable if form is invalid', (WidgetTester tester) async {

    await loadPage(tester);

    signUpPresenterSpy.emitFormError();

    await tester.pump();

    final createAccountButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(createAccountButton.onPressed, null);

  });

  testWidgets('Should call signup on form submit', (WidgetTester tester) async {

    await loadPage(tester);

    signUpPresenterSpy.emitFormValid();

    await tester.pump();
  
    final createAccountButton = find.byType(ElevatedButton);
  
    await tester.ensureVisible(createAccountButton);
    await tester.tap(createAccountButton);
    await tester.pump();
  
    verify(() => (signUpPresenterSpy.signUp())).called(1);

  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {

    await loadPage(tester);

    signUpPresenterSpy.emitLoading();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    signUpPresenterSpy.emitLoading(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    signUpPresenterSpy.emitLoading();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

  });

  testWidgets('Should present error message if signup fails', (WidgetTester tester) async { 
    
    await loadPage(tester);
    
    signUpPresenterSpy.emitMainError(UIError.emailInUse);
    
    await tester.pump();

    expect(find.text('Email já cadastrado'), findsOneWidget);

  });

  testWidgets('Should present error message if signup throws', (WidgetTester tester) async { 
    
    await loadPage(tester);
    
    signUpPresenterSpy.emitMainError(UIError.unexpected);
    
    await tester.pump();

    expect(find.text('Ocorreu um erro. Tente novamente em breve'), findsOneWidget);

  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    signUpPresenterSpy.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
    expect(find.text('navigation test'), findsOneWidget);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    signUpPresenterSpy.emitNavigateTo('');
    await tester.pumpAndSettle();

    expect(currentRoute, AppRoute.SignUpPage);

  });

  testWidgets('Should go to login on link click', (WidgetTester tester) async {

    await loadPage(tester);

    final goToLoginButton = find.byKey(ValueKey('goToLoginPage'));
  
    await tester.ensureVisible(goToLoginButton);
    await tester.tap(goToLoginButton);
    await tester.pump();
  
    verify(() => (signUpPresenterSpy.goToLogin())).called(1);

  });

}
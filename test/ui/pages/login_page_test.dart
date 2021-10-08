import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/ui/pages/login/login_page.dart';
import 'package:practice/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter loginPresenter;
  StreamController<String> emailErrorController;
  StreamController<String> passwordErrorController;
  StreamController<bool> isFormValidController;

  Future<void> loadPage(WidgetTester tester) async {

    loginPresenter = LoginPresenterSpy();

    emailErrorController = StreamController<String>();
    when(loginPresenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);

    passwordErrorController = StreamController<String>();
    when(loginPresenter.passsowrdErrorStream).thenAnswer((_) => passwordErrorController.stream);

    isFormValidController = StreamController<bool>();
    when(loginPresenter.isFormValidStream).thenAnswer((_) => isFormValidController.stream);

    final loginPage = MaterialApp(
      home: LoginPage(loginPresenter),
    );

    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
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

  testWidgets('Should enable button if form is valid', (WidgetTester tester) async {

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

}

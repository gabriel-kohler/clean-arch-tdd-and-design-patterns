import 'dart:async';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/ui/helpers/errors/errors.dart';

import 'package:practice/ui/pages/signup/signup.dart';

import 'package:practice/utils/app_routes.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}
void main() {

  SignUpPresenter signUpPresenterSpy;

  StreamController<UIError> nameErrorController;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> confirmPasswordErrorController;
  StreamController<UIError> mainErrorController;
  StreamController<String> navigateToController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;
  
  void initStreams() {
    nameErrorController = StreamController<UIError>();
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    confirmPasswordErrorController = StreamController<UIError>();
    mainErrorController = StreamController<UIError>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    navigateToController = StreamController<String>();
  }

  void mockStreams() {
    when(signUpPresenterSpy.nameErrorStream).thenAnswer((_) => nameErrorController.stream);  
    when(signUpPresenterSpy.emailErrorStream).thenAnswer((_) => emailErrorController.stream);    
    when(signUpPresenterSpy.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(signUpPresenterSpy.confirmPasswordErrorStream).thenAnswer((_) => confirmPasswordErrorController.stream);
    when(signUpPresenterSpy.isFormValidStream).thenAnswer((_) => isFormValidController.stream);    
    when(signUpPresenterSpy.isLoadingStream).thenAnswer((_) => isLoadingController.stream);    
    when(signUpPresenterSpy.mainErrorStream).thenAnswer((_) => mainErrorController.stream);
    when(signUpPresenterSpy.navigateToStream).thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    confirmPasswordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {

    signUpPresenterSpy = SignUpPresenterSpy();

    initStreams();
    mockStreams();

    final signUpPage = GetMaterialApp(
      initialRoute: AppRoute.SignUpPage,
      getPages: [
        GetPage(name: AppRoute.SignUpPage, page: () => SignUpPage(signUpPresenter: signUpPresenterSpy)),
        GetPage(name: '/any_route', page: () => Scaffold(
          body: Text('navigation test'),
        )),  
      ],
    );

    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    final email = faker.internet.email();
    final password = faker.internet.password();

    await tester.enterText(find.bySemanticsLabel('Nome'), name);

    verify(signUpPresenterSpy.validateName(name));

    await tester.enterText(find.bySemanticsLabel('Email'), email);

    verify(signUpPresenterSpy.validateEmail(email));

    await tester.enterText(find.bySemanticsLabel('Senha'), password);

    verify(signUpPresenterSpy.validatePassword(password));

    await tester.enterText(find.bySemanticsLabel('Confirmar senha'), password);

    verify(signUpPresenterSpy.validateConfirmPassword(password));
  });

  testWidgets('Should present error if name is invalid', (WidgetTester tester) async {

    await loadPage(tester);

    nameErrorController.add(UIError.invalidField);

    await tester.pump();
    
    expect(find.text('Campo inválido'), findsOneWidget);

  });

  testWidgets('Should present no error if name is valid', (WidgetTester tester) async {

    await loadPage(tester);

    nameErrorController.add(null);

    await tester.pump();

    final nameTextChildren = find.descendant(of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));

    expect(nameTextChildren, findsOneWidget);

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

  testWidgets('Should present error if password is empty', (WidgetTester tester) async {

    await loadPage(tester);

    passwordErrorController.add(UIError.requiredField);

    await tester.pump();
    
    expect(find.text('Campo obrigatório'), findsOneWidget);

  });

  testWidgets('Should present no error if password is valid', (WidgetTester tester) async {

    await loadPage(tester);

    passwordErrorController.add(null);

    await tester.pump();

    final passwordTextChildren = find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    
    expect(passwordTextChildren, findsOneWidget);

  });

  testWidgets('Should present error if confirmPassword is empty', (WidgetTester tester) async {

    await loadPage(tester);

    confirmPasswordErrorController.add(UIError.requiredField);

    await tester.pump();
    
    expect(find.text('Campo obrigatório'), findsOneWidget);

  });

  testWidgets('Should present no error if confirmPassword is valid', (WidgetTester tester) async {

    await loadPage(tester);

    confirmPasswordErrorController.add(null);

    await tester.pump();

    final confirmPasswordTextChildren = find.descendant(of: find.bySemanticsLabel('Confirmar senha'), matching: find.byType(Text));
    
    expect(confirmPasswordTextChildren, findsOneWidget);

  });

  testWidgets('Should enable button if form is valid', (WidgetTester tester) async {

    await loadPage(tester);

    isFormValidController.add(true);

    await tester.pump();

    final createAccountButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(createAccountButton.onPressed, isNotNull);

  }); 

  testWidgets('Should enable disable if form is invalid', (WidgetTester tester) async {

    await loadPage(tester);

    isFormValidController.add(false);

    await tester.pump();

    final createAccountButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(createAccountButton.onPressed, null);

  });

  testWidgets('Should call signup on form submit', (WidgetTester tester) async {

    await loadPage(tester);

    isFormValidController.add(true);

    await tester.pump();
  
    final createAccountButton = find.byType(ElevatedButton);
  
    await tester.ensureVisible(createAccountButton);
    await tester.tap(createAccountButton);
    await tester.pump();
  
    verify(signUpPresenterSpy.signUp()).called(1);

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

  testWidgets('Should present error message if signup fails', (WidgetTester tester) async { 
    
    await loadPage(tester);
    
    mainErrorController.add(UIError.emailInUse);
    
    await tester.pump();

    expect(find.text('Email já cadastrado'), findsOneWidget);

  });

  testWidgets('Should present error message if signup throws', (WidgetTester tester) async { 
    
    await loadPage(tester);
    
    mainErrorController.add(UIError.unexpected);
    
    await tester.pump();

    expect(find.text('Ocorreu um erro. Tente novamente em breve'), findsOneWidget);

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

    expect(Get.currentRoute, AppRoute.SignUpPage);

    navigateToController.add('');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, AppRoute.SignUpPage);
  });

  testWidgets('Should go to login on link click', (WidgetTester tester) async {

    await loadPage(tester);

    final goToLoginButton = find.byKey(ValueKey('goToLoginPage'));
  
    await tester.ensureVisible(goToLoginButton);
    await tester.tap(goToLoginButton);
    await tester.pump();
  
    verify(signUpPresenterSpy.goToLogin()).called(1);

  });

}
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
      ],
    );

    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should load with correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

    final nameTextChildren = find.descendant(
      of: find.bySemanticsLabel('Nome'),
      matching: find.byType(Text),
    );

    expect(nameTextChildren, findsOneWidget);

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

    final confirmPasswordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Confirmar senha'),
      matching: find.byType(Text),
    );

    expect(confirmPasswordTextChildren, findsOneWidget);

    final elevatedButtonLogin = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton),
    );

    expect(elevatedButtonLogin.onPressed, null);

    expect(find.byType(CircularProgressIndicator), findsNothing);
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

}

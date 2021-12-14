import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:practice/ui/pages/signup/signup.dart';

import 'package:practice/utils/app_routes.dart';

void main() {

  Future<void> loadPage(WidgetTester tester) async {

    final signUpPage = GetMaterialApp(
      initialRoute: AppRoute.SignUpPage,
      getPages: [
        GetPage(name: AppRoute.SignUpPage, page: () => SignUpPage()),
      ],
    );

    await tester.pumpWidget(signUpPage);
  }

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

}

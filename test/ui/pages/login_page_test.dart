import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice/ui/pages/login_page.dart';

void main() {
  Future<void> loadPage(WidgetTester tester) async {
    final loginPage = MaterialApp(home: LoginPage());
    await tester.pumpWidget(loginPage);
  }

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {

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
}

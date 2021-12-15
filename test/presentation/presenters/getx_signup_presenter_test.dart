import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:test/test.dart';

import 'package:practice/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements Validation {}
void main() {

  test('Should SignUpPresenter call Validation in email changed', ()  {

    final validationSpy = ValidationSpy();
    final sut = GetxSignUpPresenter(validation: validationSpy);
    final email = faker.internet.email();

    sut.validateEmail(email);

    verify(validationSpy.validate(field: 'email', value: email));

  });
}
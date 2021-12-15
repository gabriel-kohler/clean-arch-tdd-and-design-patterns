import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:test/test.dart';

import 'package:practice/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements Validation {}
void main() {

  Validation validationSpy;
  GetxSignUpPresenter sut;
  String email;

  setUp(() {
    validationSpy = ValidationSpy();
    sut = GetxSignUpPresenter(validation: validationSpy);
    email = faker.internet.email();
  });

  test('Should SignUpPresenter call Validation in email changed', ()  {
    sut.validateEmail(email);

    verify(validationSpy.validate(field: 'email', value: email));
  });
}
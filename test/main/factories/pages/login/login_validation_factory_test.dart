import 'package:test/test.dart';

import 'package:practice/main/factories/pages/login/login_validation_factory.dart';
import 'package:practice/validation/validators/validators.dart';
void main() {

  test('Should return the correct validations', () {
    final validations = makeLoginValidations();

    expect(validations, [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      MinLengthValidation(field: 'password', minLengthCaracters: 5),
      RequiredFieldValidation('password'),
    ]);
  });
}
import 'package:test/test.dart';

import 'package:practice/main/factories/pages/login/login_validation_factory.dart';
import 'package:practice/validation/validators/validators.dart';
void main() {

  test('Should return the correct validations', () {
    final validations = makeSignUpValidations();

    expect(validations, [
      RequiredFieldValidation('name'),
      MinLengthValidation(field: 'name', minLengthCaracters: 3),
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', minLengthCaracters: 5),
      RequiredFieldValidation('confirmPassword'),
      CompareFieldValidation(field: 'confirmPassword', fieldToCompare: 'password'),
    ]);
  });
}
import 'package:test/test.dart';

import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:practice/validation/validators/validators.dart';
void main() {

  CompareFieldValidation sut;

  setUp((){
    sut = CompareFieldValidation(field: 'any_field', valueToCompare: 'any_password_value');
  });

  test('Should return null if valueToCompare is valid', () {
    final error = sut.validate(value: 'any_password_value');

    expect(error, null);
  });

  test('Should return error if valueToCompare is invalid', () {
    final error = sut.validate(value: 'other_password_value');

    expect(error, ValidationError.invalidField);
  });

}

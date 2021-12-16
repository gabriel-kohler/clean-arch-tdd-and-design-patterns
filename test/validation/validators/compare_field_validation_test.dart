import 'package:test/test.dart';

import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:practice/validation/validators/validators.dart';
void main() {

  CompareFieldValidation sut;

  setUp((){
    sut = CompareFieldValidation(field: 'any_field', fieldToCompare: 'other_field');
    

  });

  test('Should return null if fieldToCompare is valid', () {

    final formData = {
      'any_field' : 'any_value',
      'other_field' : 'any_value',
    };

    final error = sut.validate(inputFormData: formData);

    expect(error, null);
  });

  test('Should return error if valueToCompare is invalid', () {

    final formData = {
      'any_field' : 'any_value',
      'other_field' : 'other_value',
    };

    final error = sut.validate(inputFormData: formData);

    expect(error, ValidationError.invalidField);
  });

}

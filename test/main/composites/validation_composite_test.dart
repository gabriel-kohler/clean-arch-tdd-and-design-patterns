import 'package:test/test.dart';

import 'package:practice/presentation/dependencies/validation.dart';
import 'package:practice/main/composites/composites.dart';

import '../../validation/mocks/mocks.dart';

void main() {

  late ValidationComposite sut;
  late FieldValidationSpy validation1;
  late FieldValidationSpy validation2;
  late FieldValidationSpy validation3;

  setUp(() {

    validation1 = FieldValidationSpy();
    validation1.mockFieldName('other_field');
    validation2 = FieldValidationSpy();
    validation3 = FieldValidationSpy();

    sut = ValidationComposite([validation1, validation2, validation3]);
    
  });

  test('Should return the first error', () {

    validation1.mockValidationError(ValidationError.invalidField);
    validation2.mockValidationError(ValidationError.requiredField);
    validation3.mockValidationError(ValidationError.invalidField);
    
    final error = sut.validate(field: 'any_field', inputFormData: {'any_field' : 'any_value'});

    expect(error, ValidationError.requiredField);
  });

}

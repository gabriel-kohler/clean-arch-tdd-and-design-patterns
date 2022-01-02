import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:practice/validation/dependencies/dependencies.dart';
import 'package:practice/presentation/dependencies/validation.dart';
import 'package:practice/main/composites/composites.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {

  late ValidationComposite sut;
  late FieldValidationSpy validation1;
  late FieldValidationSpy validation2;
  late FieldValidationSpy validation3;

  void mockValidation1(ValidationError? error){
    when(() => (validation1.validate(inputFormData: any(named: 'inputFormData').thenReturn(error))));
  }

  void mockValidation2(ValidationError? error){
    when(() => (validation2.validate(inputFormData: any(named: 'inputFormData').thenReturn(error))));
  }

  void mockValidation3(ValidationError? error){
    when(() => (validation3.validate(inputFormData: any(named: 'inputFormData').thenReturn(error))));
  }

  setUp(() {

    validation1 = FieldValidationSpy();
    when(() => (validation1.field)).thenReturn('other_field');
    mockValidation1(null);
    validation2 = FieldValidationSpy();
    when(() => (validation2.field)).thenReturn('any_field');
    mockValidation2(null);
    validation3 = FieldValidationSpy();
    when(() => (validation3.field)).thenReturn('any_field');
    mockValidation3(null);

    sut = ValidationComposite([validation1, validation2, validation3]);
    
  });

  test('Should return the first error', () {

    mockValidation1(ValidationError.requiredField);
    mockValidation2(ValidationError.requiredField);
    mockValidation3(ValidationError.invalidField);
    
    final error = sut.validate(field: 'any_field', inputFormData: {'any_field' : 'any_value'});

    expect(error, ValidationError.requiredField);
  });

}

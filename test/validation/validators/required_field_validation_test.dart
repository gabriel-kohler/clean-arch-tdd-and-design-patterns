import 'package:test/test.dart';

import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:practice/validation/validators/validators.dart';

void main() {

  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('Should return null if value is not empty', () {
    final error = sut.validate(inputFormData: {'any_field' : 'any_value'});

    expect(error, null);

  });

  test('Should return error if value is empty', () {
    final error = sut.validate(inputFormData: {'any_field' : ''});

    expect(error, ValidationError.requiredField);

  });

  test('Should return error if value is null', () {
    final error = sut.validate(inputFormData: {'any_field' : null});

    expect(error, ValidationError.requiredField);

  });

}
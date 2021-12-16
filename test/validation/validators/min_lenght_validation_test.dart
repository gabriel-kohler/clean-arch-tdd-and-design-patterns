import 'package:test/test.dart';

import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:practice/validation/validators/validators.dart';

void main() {

  MinLengthValidation sut;

  setUp((){
    sut = MinLengthValidation(field: 'any_field', minLengthValidation: 5);
  });

  test('Should return error if value is empty', () {
    final error = sut.validate(value: '');

    expect(error, ValidationError.invalidField);
  });

}

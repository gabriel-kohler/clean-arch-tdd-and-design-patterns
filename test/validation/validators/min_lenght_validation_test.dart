import 'package:test/test.dart';

import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:practice/validation/validators/validators.dart';

void main() {

  MinLengthValidation sut;

  setUp((){
    sut = MinLengthValidation(field: 'any_field', minLengthCaracters: 5);
  });

  test('Should return error if value is empty', () {
    final error = sut.validate(value: '');

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    final error = sut.validate(value: null);

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is smaller than minLengthCaracters', () {
    final error = sut.validate(value: '1234');

    expect(error, ValidationError.invalidField);
  });

  test('Should return null if value is equals than minLengthCaracters', () {
    final error = sut.validate(value: '12345');

    expect(error, null);
  });

  test('Should return null if value is larger than minLengthCaracters', () {
    final error = sut.validate(value: '123456');

    expect(error, null);
  });

}

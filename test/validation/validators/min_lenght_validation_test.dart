import 'package:test/test.dart';

import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:practice/validation/validators/validators.dart';

void main() {

  late MinLengthValidation sut;

  setUp((){
    sut = MinLengthValidation(field: 'any_field', minLengthCaracters: 5);
  });

  test('Should return error if value is empty', () {
    final error = sut.validate(inputFormData: {'any_field' : ''});

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    
    expect(sut.validate(inputFormData: {}), ValidationError.invalidField);
    expect(sut.validate(inputFormData: {'any_field': null}), ValidationError.invalidField);
    
  });

  test('Should return error if value is smaller than minLengthCaracters', () {
    final error = sut.validate(inputFormData: {'any_field' : '1234'});

    expect(error, ValidationError.invalidField);
  });

  test('Should return null if value is equals than minLengthCaracters', () {
    final error = sut.validate(inputFormData: {'any_field' : '12345'});

    expect(error, null);
  });

  test('Should return null if value is larger than minLengthCaracters', () {
    final error = sut.validate(inputFormData: {'any_field' : '123456'});

    expect(error, null);
  });

}

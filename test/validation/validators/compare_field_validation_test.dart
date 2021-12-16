import 'package:meta/meta.dart';
import 'package:test/test.dart';

import 'package:practice/validation/dependencies/dependencies.dart';
import 'package:practice/presentation/dependencies/validation.dart';

class CompareFieldValidation implements FieldValidation {

  final String field;
  final String valueToCompare;

  CompareFieldValidation({@required this.field, @required this.valueToCompare});

  @override
  ValidationError validate({@required String value}) {
    return null;
  }

}

void main() {

  CompareFieldValidation sut;

  setUp((){
    sut = CompareFieldValidation(field: 'any_field', valueToCompare: 'any_password_value');
  });

  test('Should return null if valueToCompare is valid', () {
    final error = sut.validate(value: 'any_password_value');

    expect(error, null);
  });

}

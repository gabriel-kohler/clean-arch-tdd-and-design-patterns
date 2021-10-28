import 'package:mockito/mockito.dart';
import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:practice/validation/dependencies/dependencies.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';


class ValidationComposite implements Validation {

  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String validate({@required String field,@required  String value}) {
    return null;
  }

}

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {

  test('Should return null if all validations returns null or empty', () {
    final validation1 = FieldValidationSpy();
    when(validation1.field).thenReturn('any_field');
    when(validation1.validate(any)).thenReturn(null);
    final validation2 = FieldValidationSpy();
    when(validation2.field).thenReturn('any_field');
    when(validation2.validate(any)).thenReturn(null);
    final validation3 = FieldValidationSpy();
    when(validation3.field).thenReturn('any_field');
    when(validation1.validate(any)).thenReturn('');

    final sut = ValidationComposite([validation1, validation2, validation3]);

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });
}
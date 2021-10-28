import 'package:mockito/mockito.dart';
import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:practice/validation/dependencies/dependencies.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String validate({@required String field, @required String value}) {
    return null;
  }
}

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {

  FieldValidationSpy validation1;
  FieldValidationSpy validation2;
  FieldValidationSpy validation3;

  void mockValidation1(String error){
    when(validation1.validate(any)).thenReturn(error);
  }

  void mockValidation2(String error){
    when(validation2.validate(any)).thenReturn(error);
  }

  void mockValidation3(String error){
    when(validation3.validate(any)).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    when(validation1.field).thenReturn('any_field');
    mockValidation1(null);
    validation2 = FieldValidationSpy();
    when(validation2.field).thenReturn('any_field');
    mockValidation2(null);
    validation3 = FieldValidationSpy();
    when(validation3.field).thenReturn('other_field');
    mockValidation3(null);
  });

  test('Should return null if all validations returns null or empty', () {

    mockValidation2('');
    
    final sut = ValidationComposite([validation1, validation2, validation3]);

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });
}

import 'package:practice/validation/dependencies/dependencies.dart';
import 'package:test/test.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  @override
  String validate(String value) {
    final regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);

    return isValid ? null : 'Campo inválido';
  }
}

void main() {

  EmailValidation sut;

  setUp((){
    sut = EmailValidation('any_field');
  });

  test('Should return null if email is empty', () {
    final error = sut.validate('');

    expect(error, null);
  });
  test('Should return null if email is null', () {
    final error = sut.validate(null);

    expect(error, null);
  });
  test('Should return null if email is valid', () {
    final error = sut.validate('kohler2014@outlook.com');

    expect(error, null);
  });

  test('Should return error if email is invalid', () {
    final error = sut.validate('kohler2014outlookcom');

    expect(error, 'Campo inválido');
  });

}

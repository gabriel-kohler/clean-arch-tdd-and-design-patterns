import 'package:practice/validation/dependencies/dependencies.dart';
import 'package:test/test.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  @override
  String validate(String value) {
    return null;
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


}

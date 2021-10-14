import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

abstract class Validation {
  validate({@required String field, @required String value});
}

class ValidationSpy extends Mock implements Validation {}

class StreamLoginPresenter {

  final Validation validation;

  StreamLoginPresenter({@required this.validation});


  validateEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}

void main() {
  test('Should call validation with correct validation', () {
    final validation = ValidationSpy();
    final sut = StreamLoginPresenter(validation: validation);
    final email = faker.internet.email();

    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });
}

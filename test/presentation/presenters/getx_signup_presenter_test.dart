import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:practice/ui/helpers/errors/errors.dart';
import 'package:test/test.dart';

import 'package:practice/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements Validation {}
void main() {

  Validation validationSpy;
  GetxSignUpPresenter sut;
  String email;

  setUp(() {
    validationSpy = ValidationSpy();
    sut = GetxSignUpPresenter(validation: validationSpy);
    email = faker.internet.email();
  });

  test('Should SignUpPresenter call Validation in email changed', ()  {
    sut.validateEmail(email);

    verify(validationSpy.validate(field: 'email', value: email));
  });

  test('Should emit invalidFieldError if email is invalid', () {
    
    when(validationSpy.validate(field: anyNamed('field'), value: anyNamed('value'))).thenReturn(ValidationError.invalidField);

    sut.emailErrorStream.listen(
      expectAsync1((error) {
        expect(error, UIError.invalidField);
      }),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) {
        expect(isValid, false);
      }),
    );

    sut.validateEmail(email);
    sut.validateEmail(email);

  });

}
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
  String name;
  String password;

  setUp(() {
    validationSpy = ValidationSpy();
    sut = GetxSignUpPresenter(validation: validationSpy);

    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
  });

  test('Should SignUpPresenter call Validation in email changed', ()  {
    sut.validateEmail(email);

    verify(validationSpy.validate(field: 'email', value: email)).called(1);
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

  test('Should emit requiredFieldError if email is empty', () {
    
    when(validationSpy.validate(field: anyNamed('field'), value: anyNamed('value'))).thenReturn(ValidationError.requiredField);

    sut.emailErrorStream.listen(
      expectAsync1((error) {
        expect(error, UIError.requiredField);
      }),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) {
        expect(isValid, false);
      }),
    );

    sut.validateEmail(email);

  });

  test('Should emit null if email is valid', () {
    
    when(validationSpy.validate(field: anyNamed('field'), value: anyNamed('value'))).thenReturn(null);

    sut.emailErrorStream.listen(
      expectAsync1((error) {
        expect(error, null);
      }),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) {
        expect(isValid, false);
      }),
    );

    sut.validateEmail(email);

  });

  test('Should SignUpPresenter call Validation in name changed', ()  {
    sut.validateName(name);

    verify(validationSpy.validate(field: 'name', value: name)).called(1);
  });

  test('Should emit invalidFieldError if name is invalid', () {
    
    when(validationSpy.validate(field: anyNamed('field'), value: anyNamed('value'))).thenReturn(ValidationError.invalidField);

    sut.nameErrorStream.listen(
      expectAsync1((error) {
        expect(error, UIError.invalidField);
      }),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) {
        expect(isValid, false);
      }),
    );

    sut.validateName(name);
    sut.validateName(name);

  });

  test('Should emit requiredFieldError if name is empty', () {
    
    when(validationSpy.validate(field: anyNamed('field'), value: anyNamed('value'))).thenReturn(ValidationError.requiredField);

    sut.nameErrorStream.listen(
      expectAsync1((error) {
        expect(error, UIError.requiredField);
      }),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) {
        expect(isValid, false);
      }),
    );

    sut.validateName(name);

  });
  
  test('Should emit null if name is valid', () {
    
    when(validationSpy.validate(field: anyNamed('field'), value: anyNamed('value'))).thenReturn(null);

    sut.nameErrorStream.listen(
      expectAsync1((error) {
        expect(error, null);
      }),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) {
        expect(isValid, false);
      }),
    );

    sut.validateName(name);

  });

  test('Should call validation with correct password', () {
    sut.validatePassword(password);

    verify(validationSpy.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit invalidFieldError if password is invalid', () {
    
    when(validationSpy.validate(field: anyNamed('field'), value: anyNamed('value'))).thenReturn(ValidationError.invalidField);

    sut.passwordErrorStream.listen(
      expectAsync1((error) {
        expect(error, UIError.invalidField);
      }),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) {
        expect(isValid, false);
      }),
    );

    sut.validatePassword(password);
    sut.validatePassword(password);

  });

  test('Should emit requiredFieldError if password is empty', () {
    
    when(validationSpy.validate(field: anyNamed('field'), value: anyNamed('value'))).thenReturn(ValidationError.requiredField);

    sut.passwordErrorStream.listen(
      expectAsync1((error) {
        expect(error, UIError.requiredField);
      }),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) {
        expect(isValid, false);
      }),
    );

    sut.validatePassword(password);

  });

  test('Should emit null if password is valid', () {
    
    when(validationSpy.validate(field: anyNamed('field'), value: anyNamed('value'))).thenReturn(null);

    sut.passwordErrorStream.listen(
      expectAsync1((error) {
        expect(error, null);
      }),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) {
        expect(isValid, false);
      }),
    );

    sut.validatePassword(password);

  });

}
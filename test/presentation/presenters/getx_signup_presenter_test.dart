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

  PostExpectation mockValidationCall() => when(validationSpy.validate(field: anyNamed('field'), value: anyNamed('value')));
  mockValidation() => mockValidationCall().thenReturn(null);
  mockValidationError({ValidationError errorReturn}) => mockValidationCall().thenReturn(errorReturn);

  test('Should SignUpPresenter call Validation in email changed', ()  {
    sut.validateEmail(email);

    verify(validationSpy.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit invalidFieldError if email is invalid', () {

    mockValidationError(errorReturn: ValidationError.invalidField);
    
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

    mockValidationError(errorReturn: ValidationError.requiredField);
    
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
    
    mockValidation();

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

    mockValidationError(errorReturn: ValidationError.invalidField);

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
    
    mockValidationError(errorReturn: ValidationError.requiredField);

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

    mockValidation();

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

    mockValidationError(errorReturn: ValidationError.invalidField);
    
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
    
    mockValidationError(errorReturn: ValidationError.requiredField);

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
    
    mockValidation();

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

  test('Should call validation with correct confirmPassword', () {
    sut.validateConfirmPassword(password);

    verify(validationSpy.validate(field: 'confirmPassword', value: password)).called(1);
  });

  test('Should emit invalidFieldError if confirmPassword is invalid', () {
    
    mockValidationError(errorReturn: ValidationError.invalidField);

    sut.confirmPasswordErrorStream.listen(
      expectAsync1((error) {
        expect(error, UIError.invalidField);
      }),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) {
        expect(isValid, false);
      }),
    );

    sut.validateConfirmPassword(password);
    sut.validateConfirmPassword(password);

  });

  test('Should emit requiredFieldError if confirmPassword is empty', () {
    
    mockValidationError(errorReturn: ValidationError.requiredField);

    sut.confirmPasswordErrorStream.listen(
      expectAsync1((error) {
        expect(error, UIError.requiredField);
      }),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) {
        expect(isValid, false);
      }),
    );

    sut.validateConfirmPassword(password);

  });

  
  test('Should emit null if confirmPassword is valid', () {
    
    mockValidation();

    sut.confirmPasswordErrorStream.listen(
      expectAsync1((error) {
        expect(error, null);
      }),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) {
        expect(isValid, false);
      }),
    );

    sut.validateConfirmPassword(password);

  });

  test('Should emits form invalid event if any field is invalid', () {

    when(validationSpy.validate(field: 'email', value: anyNamed('value'))).thenReturn(ValidationError.invalidField);
    when(validationSpy.validate(field: 'name', value: anyNamed('value'))).thenReturn(ValidationError.invalidField);
    when(validationSpy.validate(field: 'password', value: anyNamed('value'))).thenReturn(ValidationError.invalidField);
    when(validationSpy.validate(field: 'confirmPassword', value: anyNamed('value'))).thenReturn(ValidationError.invalidField);

    sut.emailErrorStream.listen(
      expectAsync1((error) {
        expect(error, UIError.invalidField);
      }),
    );

    sut.nameErrorStream.listen(
      expectAsync1((error) {
        expect(error, UIError.invalidField);
      }),
    );

    sut.passwordErrorStream.listen(
      expectAsync1((error) {
        expect(error, UIError.invalidField);
      }),
    );

    sut.confirmPasswordErrorStream.listen(
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
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validateConfirmPassword(password);

  });

  test('Should emits form valid event if any field is valid', () async {

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validateConfirmPassword(password);
    await Future.delayed(Duration.zero);

  });


}
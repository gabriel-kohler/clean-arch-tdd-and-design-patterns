import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:practice/data/usecases/local_storage/local_storage.dart';
import 'package:practice/domain/helpers/domain_error.dart';
import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/usecases/signup/add_account.dart';
import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:practice/presentation/presenters/presenters.dart';
import 'package:practice/ui/helpers/errors/errors.dart';

class ValidationSpy extends Mock implements Validation {}
class AddAccountSpy extends Mock implements AddAccount {}
class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}
void main() {

  Validation validationSpy;
  AddAccount addAccountSpy;
  SaveCurrentAccount saveCurrentAccountSpy;
  GetxSignUpPresenter sut;

  String email;
  String name;
  String password;
  String token;

  setUp(() {
    validationSpy = ValidationSpy();
    addAccountSpy = AddAccountSpy();
    saveCurrentAccountSpy = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(validation: validationSpy, addAccount: addAccountSpy, saveCurrentAccount: saveCurrentAccountSpy);

    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
    token = faker.guid.guid();
  });

  PostExpectation mockValidationCall() => when(validationSpy.validate(field: anyNamed('field'), value: anyNamed('value')));
  mockValidation() => mockValidationCall().thenReturn(null);
  mockValidationError({ValidationError errorReturn}) => mockValidationCall().thenReturn(errorReturn);

  PostExpectation mockAddAccountCall() => when(addAccountSpy.add(params: anyNamed('params')));
  void mockAddAccount({String account}) => mockAddAccountCall().thenAnswer((_) async => AccountEntity(account));
  void mockAddAccountError(DomainError error) => mockAddAccountCall().thenThrow(error);

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

  test('Should SignUpPresenter call SignUp with correct values', () async {

    final params = AddAccountParams(
      name: name,
      email: email,
      password: password,
      confirmPassowrd: password,
    );

    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validateConfirmPassword(password);

    await sut.signUp();

    verify(addAccountSpy.add(params: params)).called(1);
  });

  test('Should emit correct events on SignUp success', () async {

    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validateConfirmPassword(password);


    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.signUp();

  });

  test('Should emit correct events on EmailInUseError', () async {

    mockAddAccountError(DomainError.emainInUse);

    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validateConfirmPassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.mainErrorStream.listen(
      expectAsync1((mainError) { 
        expect(mainError, UIError.emailInUse);
      }));

    await sut.signUp();

  });

  test('Should emit correct events on UnexpectedError', () async {

    mockAddAccountError(DomainError.unexpected);

    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validateConfirmPassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.mainErrorStream.listen(
      expectAsync1((mainError) { 
        expect(mainError, UIError.unexpected);
      }));

    await sut.signUp();

  });

  test('Should call LocalSaveCurrentAccount with correct values', () async {

    mockAddAccount(account: token);

    await sut.signUp();

    verify(saveCurrentAccountSpy.save(account: AccountEntity(token))).called(1);
  });

  test('Should emit UnexpectedError if LocalSaveCurrentAccount fails', () async {

    when(saveCurrentAccountSpy.save(account: anyNamed('account'))).thenThrow(DomainError.unexpected);

    sut.mainErrorStream.listen(
      expectAsync1((mainError) { 
        expect(mainError, UIError.unexpected);
      }));

    await sut.signUp();
  });

}
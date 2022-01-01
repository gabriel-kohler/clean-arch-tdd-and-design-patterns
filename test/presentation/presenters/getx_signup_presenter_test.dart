import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/utils/app_routes.dart';
import 'package:test/test.dart';

import 'package:practice/data/usecases/local_storage/local_storage.dart';
import 'package:practice/domain/helpers/domain_error.dart';
import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/usecases/signup/add_account.dart';
import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:practice/presentation/presenters/presenters.dart';
import 'package:practice/ui/helpers/errors/errors.dart';

import '../../mocks/fake_account_factory.dart';

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
  AccountEntity account;

  setUp(() {
    validationSpy = ValidationSpy();
    addAccountSpy = AddAccountSpy();
    saveCurrentAccountSpy = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(validation: validationSpy, addAccount: addAccountSpy, saveCurrentAccount: saveCurrentAccountSpy);

    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
  });

  PostExpectation mockValidationCall() => when(validationSpy.validate(field: anyNamed('field'), inputFormData: anyNamed('inputFormData')));
  mockValidation() => mockValidationCall().thenReturn(null);
  mockValidationError({ValidationError errorReturn}) => mockValidationCall().thenReturn(errorReturn);

  PostExpectation mockAddAccountCall() => when(addAccountSpy.add(params: anyNamed('params')));

  void mockAddAccount(AccountEntity data) {
    account = data;
    mockAddAccountCall().thenAnswer((_) async => data);
  }

  void mockAddAccountError(DomainError error) => mockAddAccountCall().thenThrow(error);

  test('Should SignUpPresenter call Validation in email changed', ()  {

    final formData = {
      'name' : null,
      'email' : email,
      'password' : null,
      'confirmPassword' : null,
    };

    sut.validateEmail(email);

    verify(validationSpy.validate(field: 'email', inputFormData: formData)).called(1);
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

    final formData = {
      'name' : name,
      'email' : null,
      'password' : null,
      'confirmPassword' : null,
    };

    sut.validateName(name);

    verify(validationSpy.validate(field: 'name', inputFormData: formData)).called(1);
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

    final formData = {
      'name' : null,
      'email' : null,
      'password' : password,
      'confirmPassword' : null,
    };

    sut.validatePassword(password);

    verify(validationSpy.validate(field: 'password', inputFormData: formData)).called(1);
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

    final formData = {
      'name' : null,
      'email' : null,
      'password' : null,
      'confirmPassword' : password,
    };

    sut.validateConfirmPassword(password);

    verify(validationSpy.validate(field: 'confirmPassword', inputFormData: formData)).called(1);
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

    when(validationSpy.validate(field: 'email', inputFormData: anyNamed('inputFormData'))).thenReturn(ValidationError.invalidField);
    when(validationSpy.validate(field: 'name', inputFormData: anyNamed('inputFormData'))).thenReturn(ValidationError.invalidField);
    when(validationSpy.validate(field: 'password', inputFormData: anyNamed('inputFormData'))).thenReturn(ValidationError.invalidField);
    when(validationSpy.validate(field: 'confirmPassword', inputFormData: anyNamed('inputFormData'))).thenReturn(ValidationError.invalidField);

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


    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emits(true));

    await sut.signUp();

  });

  test('Should emit correct events on EmailInUseError', () async {

    mockAddAccountError(DomainError.emainInUse);

    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validateConfirmPassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.emailInUse]));

    await sut.signUp();

  });

  test('Should emit correct events on UnexpectedError', () async {

    mockAddAccountError(DomainError.unexpected);

    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validateConfirmPassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.signUp();

  });

  test('Should call LocalSaveCurrentAccount with correct values', () async {

    mockAddAccount(FakeAccountFactory.makeAccountEntity());

    await sut.signUp();

    verify(saveCurrentAccountSpy.save(account: account)).called(1);
  });

  test('Should emit UnexpectedError if LocalSaveCurrentAccount fails', () async {

    when(saveCurrentAccountSpy.save(account: anyNamed('account'))).thenThrow(DomainError.unexpected);
    
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.signUp();
  });

  test('Should SignUpPage navigate to HomePage if SignUp success', () async {
    
    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validateConfirmPassword(password);

    sut.navigateToStream.listen(
      expectAsync1((page) {
        expect(page, AppRoute.SurveysPage);
      }),
    );

    await sut.signUp();

  });

  test('Should SignUpPage navigate to LoginPage on link click', () async {

    sut.navigateToStream.listen(
      expectAsync1((page) {
        expect(page, AppRoute.LoginPage);
      }),
    );

    sut.goToLogin();

  });

}
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice/utils/app_routes.dart';
import 'package:test/test.dart';

import 'package:practice/domain/helpers/domain_error.dart';
import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/usecases/signup/add_account.dart';
import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:practice/presentation/presenters/presenters.dart';
import 'package:practice/ui/helpers/errors/errors.dart';

import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {

  late ValidationSpy validationSpy;
  late AddAccountSpy addAccountSpy;
  late AddCurrentAccountSpy saveCurrentAccountSpy;
  late GetxSignUpPresenter sut;

  late String email;
  late String name;
  late String password;
  late AccountEntity account;
  late AddAccountParams addAccountParams;

  setUp(() {
    validationSpy = ValidationSpy();
    addAccountSpy = AddAccountSpy();
    saveCurrentAccountSpy = AddCurrentAccountSpy();
    sut = GetxSignUpPresenter(validation: validationSpy, addAccount: addAccountSpy, saveCurrentAccount: saveCurrentAccountSpy);

    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();

    addAccountSpy.mockAddAccount(account);
    validationSpy.mockValidation();
    saveCurrentAccountSpy.mockSaveCurrentAccount();
  });

  setUpAll(() {
    addAccountParams = ParamsFactory.makeAddAccountParams();
    account = EntityFactory.makeAccountEntity();
    registerFallbackValue(account);
    registerFallbackValue(addAccountParams);
  });
  test('Should SignUpPresenter call Validation in email changed', ()  {

    final formData = {
      'name' : null,
      'email' : email,
      'password' : null,
      'confirmPassword' : null,
    };

    sut.validateEmail(email);

    verify(() => (validationSpy.validate(field: 'email', inputFormData: formData))).called(1);
  });

  test('Should emit invalidFieldError if email is invalid', () {

    validationSpy.mockValidationError(value: ValidationError.invalidField);
    
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

    validationSpy.mockValidationError(value: ValidationError.requiredField);
    
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
    
    validationSpy.mockValidation();

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

    verify(() => (validationSpy.validate(field: 'name', inputFormData: formData))).called(1);
  });

  test('Should emit invalidFieldError if name is invalid', () {

    validationSpy.mockValidationError(value: ValidationError.invalidField);

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
    
    validationSpy.mockValidationError(value: ValidationError.requiredField);

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

    validationSpy.mockValidation();

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

    verify(() => (validationSpy.validate(field: 'password', inputFormData: formData))).called(1);
  });

  test('Should emit invalidFieldError if password is invalid', () {

    validationSpy.mockValidationError(value: ValidationError.invalidField);
    
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
    
    validationSpy.mockValidationError(value: ValidationError.requiredField);

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
    
    validationSpy.mockValidation();

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

    verify(() => (validationSpy.validate(field: 'confirmPassword', inputFormData: formData))).called(1);
  });

  test('Should emit invalidFieldError if confirmPassword is invalid', () {
    
    validationSpy.mockValidationError(value: ValidationError.invalidField);

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
    
    validationSpy.mockValidationError(value: ValidationError.requiredField);

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
    
    validationSpy.mockValidation();

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

    validationSpy.mockValidationError(field: 'email', value: ValidationError.invalidField);
    validationSpy.mockValidationError(field: 'name', value: ValidationError.invalidField);
    validationSpy.mockValidationError(field: 'password', value: ValidationError.invalidField);
    validationSpy.mockValidationError(field: 'confirmPassword', value: ValidationError.invalidField);

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
    
    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validateConfirmPassword(password);

    await sut.signUp();

    verify(() => (addAccountSpy.add(
      params: AddAccountParams(
      name: name, 
      email: email, 
      password: password, 
      confirmPassowrd: password),
    ))).called(1);
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

    addAccountSpy.mockAddAccountError(DomainError.emainInUse);

    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validateConfirmPassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.emailInUse]));

    await sut.signUp();

  });

  test('Should emit correct events on UnexpectedError', () async {

    addAccountSpy.mockAddAccountError(DomainError.unexpected);

    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validateConfirmPassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.signUp();

  });

  test('Should call LocalSaveCurrentAccount with correct values', () async {

    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validateConfirmPassword(password);

    await sut.signUp();

    verify(() => (saveCurrentAccountSpy.save(account: account))).called(1);
  });

  test('Should emit UnexpectedError if LocalSaveCurrentAccount fails', () async {

    addAccountSpy.mockAddAccountError(DomainError.unexpected);

    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validateConfirmPassword(password);

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
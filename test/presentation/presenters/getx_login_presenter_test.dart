import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:practice/utils/app_routes.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/domain/usecases/usecases.dart';

import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:practice/presentation/presenters/presenters.dart';

import 'package:practice/ui/helpers/errors/errors.dart';

import '../../mocks/fake_account_factory.dart';

class ValidationSpy extends Mock implements Validation {}
class AuthenticationSpy extends Mock implements Authentication {}
class AddCurrentAccountSpy extends Mock implements AddCurrentAccount {}

void main() {
  AuthenticationSpy authentication;
  ValidationSpy validation;
  AddCurrentAccount localSaveCurrentAccountSpy;
  GetxLoginPresenter sut;
  String email;
  String password;
  AccountEntity account;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      inputFormData: anyNamed('inputFormData')));

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() => when(authentication.auth(params: anyNamed('params')));

  void mockAuthentication(AccountEntity data) {
    account = data;
    mockAuthenticationCall().thenAnswer((_) async => data);
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    authentication = AuthenticationSpy();
    validation = ValidationSpy();
    localSaveCurrentAccountSpy = AddCurrentAccountSpy();
    sut = GetxLoginPresenter(validation: validation, authentication: authentication, localSaveCurrentAccount: localSaveCurrentAccountSpy);
    email = faker.internet.email();
    password = faker.internet.password();

    mockValidation();
    mockAuthentication(FakeAccountFactory.makeAccountEntity());
  });

  test('Should call validation with correct email', () {

    final formData = {
      'email' : email,
      'password' : null,
    };

    sut.validateEmail(email);

    verify(validation.validate(field: 'email', inputFormData: formData)).called(1);
  });

  test('Should emit invalidFieldError if email is invalid', () {
    mockValidation(value: ValidationError.invalidField);

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
    mockValidation(value: ValidationError.requiredField);

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
    sut.validateEmail(email);

  });

  test('Should emit null if email validation return success', () {

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
    sut.validateEmail(email);

  });

  test('Should call validation with correct password', () {

    final formData = {
      'email' : null,
      'password' : password,
    };

    sut.validatePassword(password);

    verify(validation.validate(field: 'password', inputFormData: formData)).called(1);
  });

  test('Should emit requiredFieldError if password is empty', () {
    mockValidation(value: ValidationError.requiredField);

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
    sut.validatePassword(password);

  });

  test('Should emit null if password validation return success', () {

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
    sut.validatePassword(password);
  });

  test('Should emits form invalid event if any field is invalid', () {

    mockValidation(field: 'email', value: ValidationError.invalidField);

    //if password field is valid but email field is invalid, test must fail

    sut.emailErrorStream.listen(
      expectAsync1((error) {
        expect(error, UIError.invalidField);
      }),
    );

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

    sut.validateEmail(email);
    sut.validatePassword(password);

  });

  test('Should emits form valid event if form is valid', () async {

    sut.emailErrorStream.listen(
      expectAsync1((error) {
        expect(error, null);
      }),
    );

    sut.passwordErrorStream.listen(
      expectAsync1((error) {
        expect(error, null);
      }),
    );

     expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);

  });

  test('Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(
      authentication.auth(
        params: AuthenticationParams(
          email: email, 
          password: password
        ),
      ),       
    ).called(1);
    
  });

  test('Should emit correct events on Authentication success', () async {

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.auth();
    
  });

  test('Should emit correct events on InvalidCredentialError', () async {

    mockAuthenticationError(DomainError.invalidCredentials);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.invalidCredentials]));

    await sut.auth();
    
  });

  test('Should emit correct events on UnexpectedError', () async {

    mockAuthenticationError(DomainError.unexpected);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
    
  });

  test('Should call LocalSaveCurrentAccount with correct values', () async {

    await sut.auth();

    verify(localSaveCurrentAccountSpy.save(account: account)).called(1);
  });

  test('Should emit UnexpectedError if LocalSaveCurrentAccount fails', () async {

    when(localSaveCurrentAccountSpy.save(account: anyNamed('account'))).thenThrow(DomainError.unexpected);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();

  });

  test('Should LoginPage navigate to home page if authenticate success', () async {
    
    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream.listen(
      expectAsync1((page) {
        expect(page, AppRoute.SurveysPage);
      }),
    );

    await sut.auth();

  });

  test('Should go to SignUpPage on link click', () async {
    
    sut.navigateToStream.listen(
      expectAsync1((page) {
        expect(page, AppRoute.SignUpPage);
      }),
    );

    sut.goToSignUp();

  });

}
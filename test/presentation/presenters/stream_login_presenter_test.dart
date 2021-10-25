import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:practice/domain/entities/account_entity.dart';
import 'package:practice/domain/helpers/domain_error.dart';
import 'package:practice/domain/usecases/usecases.dart';

import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:practice/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements Validation {}
class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  AuthenticationSpy authentication;
  ValidationSpy validation;
  StreamLoginPresenter sut;
  String email;
  String password;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      value: anyNamed('value')));

  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() => when(authentication.auth(params: anyNamed('params')));

  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer((_) async => AccountEntity('any_value'));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    authentication = AuthenticationSpy();
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
    mockAuthentication();
  });

  test('Should call validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream.listen(
      expectAsync1((error) {
        expect(error, 'error');
      }),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) {
        expect(isValid, false);
      }),
    );

    expectLater(sut.emailErrorStream, emits('error'));

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
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if validation fails', () {

    mockValidation(field: 'password', value: 'error');

    sut.passwordErrorStream.listen(
      expectAsync1((error) {
        expect(error, 'error');
      }),
    );

    expectLater(sut.passwordErrorStream, emits('error'));

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

    mockValidation(field: 'email', value: 'error');

    //if password field is valid but email field is invalid, test must fail

    sut.emailErrorStream.listen(
      expectAsync1((error) {
        expect(error, 'error');
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

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
    
  });

  test('Should emit correct events on InvalidCredentialError', () async {

    mockAuthenticationError(DomainError.invalidCredentials);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));

    sut.mainErrorStream.listen(
      expectAsync1((error) {
        expect(error, 'Credenciais inválidas');
      }),
    );

    await sut.auth();
    
  });

  test('Should emit correct events on UnexpectedError', () async {

    mockAuthenticationError(DomainError.unexpected);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));

    sut.mainErrorStream.listen(
      expectAsync1((error) {
        expect(error, 'Ocorreu um erro. Tente novamente em breve');
      }),
    );

    await sut.auth();
    
  });

  test('Should not emit after dispose', () async {

    expectLater(sut.emailErrorStream, neverEmits(null));

    sut.dispose();
    sut.validateEmail(email);
    
  });


}

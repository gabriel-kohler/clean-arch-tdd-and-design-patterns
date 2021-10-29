import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/domain/helpers/helpers.dart';

import 'package:practice/domain/usecases/authentication.dart';

import 'package:practice/data/usecases/remote_authentication.dart';
import 'package:practice/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClient httpClient;
  String url;
  RemoteAuthentication sut;
  AuthenticationParams params;

  Map mockValidData() => {'accessToken': faker.person.name(), 'name': faker.guid.guid()};

  PostExpectation mockRequest() => when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')));
  

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);

    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    mockHttpData(mockValidData()); //qualquer teste que não faça nada, por padrão ele vai mockar um caso de sucesso
  });

  test('Should call httpClient with correct values', () async {

    await sut.auth(params: params);

    final body = {
      'email': params.email,
      'password': params.password,
    };

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: body,
    ));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {

    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () {

    mockHttpError(HttpError.notFound);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {

    mockHttpError(HttpError.serverError);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401', () async {

    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.invalidCredentials));

  });

  test('Should return an Account if HttpClient returns 200', () async {

    final validData = mockValidData();

    mockHttpData(validData);

    final account  = await sut.auth(params: params);

    expect(account.token, validData['accessToken']);

  });

   test('Should return an UnexpectedError if HttpClient returns 200 with invalid data', () async {

    mockHttpData({'invalid_key': 'invalid_value'});

    final future  = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });
 
}

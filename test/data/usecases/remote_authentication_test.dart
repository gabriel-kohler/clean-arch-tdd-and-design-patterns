import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/domain/helpers/helpers.dart';

import 'package:practice/domain/usecases/authentication.dart';

import 'package:practice/data/usecases/remote_authentication.dart';
import 'package:practice/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClient? httpClient;
  String? url;
  RemoteAuthentication? sut;
  AuthenticationParams? params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);

    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
  });

  test('Should call httpClient with correct values', () async {

    final name = faker.person.name();
    final accessToken = faker.guid.guid();

    when(httpClient!.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body'))).thenAnswer((_) async => {'accessToken': accessToken, 'name': name});

    await sut!.auth(params!);

    final body = {
      'email': params!.email,
      'password': params!.password,
    };

    verify(httpClient!.request(
      url: url,
      method: 'post',
      body: body,
    ));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {

    when(httpClient!.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body'))).thenThrow(HttpError.badRequest);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () {

    when(httpClient!.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body'))).thenThrow(HttpError.notFound);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {

    when(httpClient!.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body'))).thenThrow(HttpError.serverError);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401', () async {

    when(httpClient!.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body'))).thenThrow(HttpError.unauthorized);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.invalidCredentials));

  });

  test('Should return an Account if HttpClient returns 200', () async {

    final accessToken = faker.guid.guid();
    final name = faker.person.name();

    when(httpClient!.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body'))).thenAnswer((_) async => {'accessToken': accessToken, 'name': name});

    final account  = await sut!.auth(params!);

    expect(account.token, accessToken);

  });

   test('Should return an UnexpectedError if HttpClient returns 200 with invalid data', () async {

    when(httpClient!.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body'))).thenAnswer((_) async => {'invalid_key': 'invalid_value'});

    final future  = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });
 
}

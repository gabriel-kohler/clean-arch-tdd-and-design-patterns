import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/domain/usecases/auth/authentication.dart';

import 'package:practice/data/usecases/auth/remote_authentication.dart';
import 'package:practice/data/http/http.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late HttpClientSpy httpClient;
  late String url;
  late RemoteAuthentication sut;
  late AuthenticationParams params;
  late Map apiResult;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);

    params = ParamsFactory.makeAuthenticationParams();
    apiResult = ApiFactory.makeAccountJson();

    httpClient.mockHttpData(apiResult);
  });

  test('Should call httpClient with correct values', () async {

    await sut.auth(params: params);

    final body = {
      'email': params.email,
      'password': params.password,
    };

    verify(() => (httpClient.request(
      url: url,
      method: 'post',
      body: body,
    )));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {

    httpClient.mockHttpError(HttpError.badRequest);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () {

    httpClient.mockHttpError(HttpError.notFound);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {

    httpClient.mockHttpError(HttpError.serverError);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401', () async {

    httpClient.mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.invalidCredentials));

  });

  test('Should return an Account if HttpClient returns 200', () async {

    final account  = await sut.auth(params: params);

    expect(account.token, apiResult['accessToken']);

  });

   test('Should return an UnexpectedError if HttpClient returns 200 with invalid data', () async {

    httpClient.mockHttpData({'invalid_key': 'invalid_value'});

    final future  = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });
 
}

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';


import 'package:practice/data/usecases/usecases.dart';
import 'package:practice/data/http/http.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/domain/usecases/signup/add_account.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';
void main() {

  late String url;
  late HttpClientSpy httpClient;
  late RemoteAddAccount sut;
  late AddAccountParams params;
  late Map apiResult;

  

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);

    apiResult = ApiFactory.makeAccountJson();
    params = ParamsFactory.makeAddAccountParams();

    httpClient.mockHttpData(apiResult);

  });

  test('Should RemoteAddAccount calls HttpClient with correct params', () async {
    
    final body = {
      'name' : params.name,
      'email' : params.email,
      'password' : params.password,
      'confirmPassword' : params.confirmPassowrd,
    };

    await sut.add(params: params);

    verify(() => (httpClient.request(url: url, method: 'post', body: body))).called(1);
  });

  test('Should throw UnexpetedError if HttpClient returns 400', () async {

    httpClient.mockHttpError(HttpError.badRequest);

    final future = sut.add(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw EmailInUseError if HttpClient returns 403', () async {

    httpClient.mockHttpError(HttpError.forbidden);

    final future = sut.add(params: params);

    expect(future, throwsA(DomainError.emainInUse));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () {

    httpClient.mockHttpError(HttpError.notFound);

    final future = sut.add(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {

    httpClient.mockHttpError(HttpError.serverError);

    final future = sut.add(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should return AccountEntity if HttpClient returns 200', () async {
    
    final account = await sut.add(params: params);

    expect(account, AccountEntity(apiResult['accessToken']));
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {

    httpClient.mockHttpData({'invalid_key' : 'invalid_value'});

    final future = sut.add(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

}
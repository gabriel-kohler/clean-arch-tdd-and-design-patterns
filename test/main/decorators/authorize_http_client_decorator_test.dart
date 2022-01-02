import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:practice/data/http/http.dart';

import 'package:practice/main/decorators/decorators.dart';

import '../../data/mocks/mocks.dart';


void main() {
  late SecureCacheStorageSpy secureCacheStorageSpy;
  late HttpClientSpy httpClient;
  late AuthorizeHttpClientDecorator sut;

  late String url;
  late String method;
  late Map body;
  late String token;
  late String httpResponse;

  setUp(() {
    secureCacheStorageSpy = SecureCacheStorageSpy();
    httpClient = HttpClientSpy();

    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: secureCacheStorageSpy, 
      decoratee: httpClient, 
      deleteSecureCacheStorage: secureCacheStorageSpy,
    );

    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key' : 'any_value'};

    token = faker.guid.guid();
    httpResponse = faker.randomGenerator.string(50);

    httpClient.mockHttpData(httpResponse);
    secureCacheStorageSpy.mockFetchSecure(token);

  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    
    await sut.request(url: url, method: method, body: body);

    verify(() => (secureCacheStorageSpy.fetchSecure(key: 'token'))).called(1);

  });
 
  test('Should call decoratee with access token on header', () async {

    await sut.request(url: url, method: method, body: body);
    verify(() => (httpClient.request(url: url, method: method, body: body, headers: {'x-access-token' : token}))).called(1);

    await sut.request(url: url, method: method, body: body, headers: {'any_header' : 'any_value'});
    verify(() => (httpClient.request(url: url, method: method, body: body, headers: {'x-access-token' : token, 'any_header' : 'any_value'}))).called(1);

  });

  test('Should return same result as decoratee', () async {
    
    final response = await sut.request(url: url, method: method, body: body);

    expect(response, httpResponse);

  });

  test('Should throw ForbbidenError if FetchSecureCacheStorage throws', () async {
    
    secureCacheStorageSpy.mockFetchSecureError();

    final future =  sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));
    verify(() => (secureCacheStorageSpy.deleteSecure(key: 'token'))).called(1);

  });

  test('Should rethrow if decoratee throws', () async {
    
    httpClient.mockHttpError(HttpError.badRequest);

    final future =  sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.badRequest));

  });

  test('Should delete cache if request throws ForbiddenError', () async {
    
    httpClient.mockHttpError(HttpError.forbidden);

    final future =  sut.request(url: url, method: method, body: body);
    await untilCalled(() => secureCacheStorageSpy.deleteSecure(key: 'token'));

    expect(future, throwsA(HttpError.forbidden));
    verify(() => (secureCacheStorageSpy.deleteSecure(key: 'token'))).called(1);

  });

}
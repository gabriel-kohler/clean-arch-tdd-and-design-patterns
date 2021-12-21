import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:practice/data/http/http.dart';
import 'package:practice/data/cache/cache.dart';

import 'package:practice/main/decorators/decorators.dart';

class FetchSecureCacheSpy extends Mock implements FetchSecureCurrentAccount {}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  FetchSecureCurrentAccount fetchSecureCacheSpy;
  HttpClient httpClient;
  AuthorizeHttpClientDecorator sut;

  String url;
  String method;
  Map body;
  String token;
  String httpResponse;

  setUp(() {
    fetchSecureCacheSpy = FetchSecureCacheSpy();
    httpClient = HttpClientSpy();
    sut = AuthorizeHttpClientDecorator(fetchSecureCacheStorage: fetchSecureCacheSpy, decoratee: httpClient);

    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key' : 'any_value'};

  });

  void mockToken() {
    token = faker.guid.guid();
    when(fetchSecureCacheSpy.fetchSecure(key: anyNamed('key'))).thenAnswer((_) async => token);
  }

  PostExpectation mockHttpResponseCall() => when(httpClient.request(
      url: anyNamed('url'), 
      method: anyNamed('method'), 
      body: anyNamed('body'), 
      headers: anyNamed('headers')));

  void mockHttpResponse() {
    httpResponse = 'any_response';

    mockHttpResponseCall().thenAnswer((_) async => httpResponse);
  }

  void mockHttpResponseError(HttpError error) => mockHttpResponseCall().thenThrow(error);

  PostExpectation mockFetchSecureCall() => when(fetchSecureCacheSpy.fetchSecure(key: anyNamed('key')));

  void mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

  test('Should call FetchSecureCacheStorage with correct key', () async {
    
    await sut.request(url: url, method: method, body: body);

    verify(fetchSecureCacheSpy.fetchSecure(key: 'token')).called(1);

  });
 
  test('Should call decoratee with access token on header', () async {

    mockToken();
    
    await sut.request(url: url, method: method, body: body);
    verify(httpClient.request(url: url, method: method, body: body, headers: {'x-access-token' : token})).called(1);

    await sut.request(url: url, method: method, body: body, headers: {'any_header' : 'any_value'});
    verify(httpClient.request(url: url, method: method, body: body, headers: {'x-access-token' : token, 'any_header' : 'any_value'})).called(1);

  });

  test('Should return same result as decoratee', () async {
    
    mockHttpResponse();

    final response = await sut.request(url: url, method: method, body: body);

    expect(response, httpResponse);

  });

  test('Should throw ForbbidenError if FetchSecureCurrentAccount throws', () async {
    
    mockFetchSecureError();

    final future =  sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));

  });

  test('Should rethrow if decoratee throws', () async {
    
    mockHttpResponseError(HttpError.badRequest);

    final future =  sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.badRequest));

  });

}
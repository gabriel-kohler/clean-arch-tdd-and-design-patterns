import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/domain/helpers/domain_error.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:practice/data/http/http.dart';

import 'package:practice/domain/usecases/signup/add_account.dart';

class HttpClientSpy extends Mock implements HttpClient {}

class RemoteAddAccountParams {
  final AddAccountParams params;

  RemoteAddAccountParams({@required this.params});

  factory RemoteAddAccountParams.fromDomain(AddAccountParams params) => RemoteAddAccountParams(params: params);

  toJson() => {
    'name' : params.name,
    'email' : params.email,
    'password' : params.password,
    'confirmPassword' : params.confirmPassowrd,
  };

}

class RemoteAddAccount {

  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({@required this.httpClient, @required this.url});

  Future<void> add({@required AddAccountParams params}) async {

    final body = RemoteAddAccountParams.fromDomain(params).toJson();

    try {
      await httpClient.request(url: url, method: 'post', body: body);
    } on HttpError {
      throw DomainError.unexpected;
    }


  }
}
void main() {

  String url;
  HttpClient httpClient;
  RemoteAddAccount sut;
  AddAccountParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);

    params = AddAccountParams(
      email: faker.internet.email(), 
      password: faker.internet.password(), 
      confirmPassowrd: faker.internet.password(), 
      name: faker.person.name(),
    );

  });

  test('Should RemoteAddAccount calls HttpClient with correct params', () async {
    
    final body = {
      'name' : params.name,
      'email' : params.email,
      'password' : params.password,
      'confirmPassword' : params.confirmPassowrd,
    };

    await sut.add(params: params);

    verify(httpClient.request(url: url, method: 'post', body: body)).called(1);
  });

  test('Should throw UnexpetedError if HttpClient returns 400', () async {

    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body'))).thenThrow(HttpError.badRequest);

    final future = sut.add(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

}
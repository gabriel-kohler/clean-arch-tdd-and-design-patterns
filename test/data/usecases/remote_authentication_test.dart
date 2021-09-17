import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:practice/domain/usecases/authentication.dart';

import 'package:practice/data/usecases/remote_authentication.dart';
import 'package:practice/data/http/http.dart';




class HttpClientSpy extends Mock implements HttpClient {}



void main() {
  HttpClient? httpClient;
  String? url;
  RemoteAuthentication? sut;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call httpClient with correct values', () async {
    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    await sut!.auth(params);

    final body = {
      'email': params.email,
      'password': params.password,
    };

    verify(httpClient!.request(
      url: url,
      method: 'post',
      body: body,
    ));
  });
}

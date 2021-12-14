import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/data/http/http.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:practice/domain/usecases/signup/add_account.dart';

class HttpClientSpy extends Mock implements HttpClient {}

class RemoteAddAccount {

  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({@required this.httpClient, @required this.url});

  Future<void> add({@required AddAccountParams params}) async {

    final body = {
      'name' : params.name,
      'email' : params.email,
      'password' : params.password,
      'confirmPassword' : params.confirmPassowrd,
    };

    await httpClient.request(url: url, method: 'post', body: body);

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
}
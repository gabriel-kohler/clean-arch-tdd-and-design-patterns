import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class ClientSpy extends Mock implements Client  {}

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request(String url) async  {
    await client.post(Uri.parse(url));
  }
}


void main() {
  

  group('post', () {
    test('Should call post with correct values', () async {

      final client = ClientSpy();
      final sut = HttpAdapter(client);
      final url = faker.internet.httpUrl();

      sut.request(url);

      verify(client.post(Uri.parse(url)));
    });
  });
}
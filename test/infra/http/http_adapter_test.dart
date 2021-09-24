import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/data/http/http.dart';

class ClientSpy extends Mock implements Client {}

class HttpAdapter implements HttpClient{
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    final jsonBody = body != null ? jsonEncode(body) : null;

    final response = await client.post(Uri.parse(url), headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } else {
      return null;
    }
  }
}

void main() {
  ClientSpy client;
  HttpAdapter sut;
  String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('post', () {

    mockRequest() => when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body')));

    mockResponse(int statusCode, {String body = '{"any_key" : "any_value"}'}) => mockRequest().thenAnswer((_) async => Response(body, statusCode));

    setUp(() {
      mockResponse(200);
    });
    test('Should call post with correct values', () async {

      await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(client.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode({'any_key': 'any_value'}),
      ));
    });

    test('Should call post without body', () async {

      await sut.request(url: url, method: 'post');

      verify(client.post(
        any,
        headers: anyNamed('headers'),
      ));
    });

    test('Should return data if post returns 200', () async {

      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any_key' : 'any_value'});
    });

    test('Should return null if post returns 200 without data', () async {

      mockResponse(200, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return null if post returns 204', () async {

      mockResponse(204, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return null if post returns 204 with data', () async {

      mockResponse(204);

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

  });
}

import 'package:mocktail/mocktail.dart';

import 'package:http/http.dart';

class ClientSpy extends Mock implements Client {

  When mockPostCall() => when(() => this.post(any(), headers: any(named: 'headers'), body: any(named: 'body')));
  mockPost(int statusCode, {String body = '{"any_key" : "any_value"}'}) => this.mockPostCall().thenAnswer((_) async => Response(body, statusCode));
  mockPostError() => this.mockPostCall().thenThrow(Exception());
  
  mockGetCall() => when(() => this.get(any(), headers: any(named: 'headers')));
  mockGet(int statusCode, {String body = '{"any_key" : "any_value"}'}) => this.mockGetCall().thenAnswer((_) async => Response(body, statusCode));
  mockGetError() => this.mockGetCall().thenThrow(Exception());

  mockPutCall() => when(() => this.put(any(), headers: any(named: 'headers'), body: any(named: 'body')));
  mockPut(int statusCode, {String body = '{"any_key" : "any_value"}'}) => this.mockPutCall().thenAnswer((_) async => Response(body, statusCode));
  mockPutError() => this.mockPutCall().thenThrow(Exception());

} 
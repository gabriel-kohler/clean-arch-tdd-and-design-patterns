import 'package:mocktail/mocktail.dart';

import 'package:practice/data/http/http.dart';


class HttpClientSpy extends Mock implements HttpClient {

  When mockHttpCall() => when(() => this.request(
    url: any(named: 'url'), 
    method: any(named: 'method'), 
    body: any(named: 'body'), 
    headers: any(named: 'headers')),
  );
  
  void mockHttpError(HttpError error) => this.mockHttpCall().thenThrow(error);
  void mockHttpData(dynamic data) => this.mockHttpCall().thenAnswer((_) async => data);

}
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:practice/data/usecases/usecases.dart';
import 'package:practice/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}
void main() {

  HttpClient httpClient;
  String url;
  RemoteSaveSurveyResult sut;
  String answer;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteSaveSurveyResult(httpClient: httpClient, url: url);
    answer = faker.lorem.sentence();
  });


  test('Should call HttpClient with correct values', () async {

    await sut.save(answer: answer);

    verify(httpClient.request(url: url, method: 'put', body: {'answer' : answer})).called(1);

  });
  
}
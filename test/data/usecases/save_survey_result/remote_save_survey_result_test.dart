import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/data/usecases/usecases.dart';
import 'package:practice/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}
void main() {

  HttpClient httpClient;
  String url;
  RemoteSaveSurveyResult sut;
  String answer;

  PostExpectation mockRequest() => when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')));
  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

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

  test('Should throw AccessDeniedError if HttpClient returns 403', () async {

    mockHttpError(HttpError.forbidden);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {


    mockHttpError(HttpError.notFound);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });
  
  test('Should throw UnexpectedError if HttpClient returns 500', () async {

    mockHttpError(HttpError.serverError);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });
  
}
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/domain/entities/entities.dart';
import 'package:practice/data/usecases/usecases.dart';
import 'package:practice/data/http/http.dart';

import '../../../mocks/mocks.dart';

class HttpClientSpy extends Mock implements HttpClient {}
void main() {

  HttpClient httpClient;
  String url;
  RemoteLoadSurveys sut;
  List<Map> listData;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteLoadSurveys(httpClient: httpClient, url: url);
  });

  PostExpectation mockRequest() => when(httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  void mockHttpData(List<Map> data) {
    listData = data;
    mockRequest().thenAnswer((_) async => data);
  }


  test('Should call HttpClient with correct values', () async {

    mockHttpData(FakeSurveysFactory.makeApiJson());
    
    await sut.load();

    verify(httpClient.request(url: url, method: 'get')).called(1);

  });

  test('Should return surveys on 200', () async {

    mockHttpData(FakeSurveysFactory.makeApiJson()); 

    final listSurveys = await sut.load();

    final mockSurvers = [
      SurveyEntity(id: listData[0]['id'], question: listData[0]['question'], date: DateTime.parse(listData[0]['date']), didAnswer: listData[0]['didAnswer']),
      SurveyEntity(id: listData[1]['id'], question: listData[1]['question'], date: DateTime.parse(listData[1]['date']), didAnswer: listData[1]['didAnswer']),
    ];

    expect(listSurveys, mockSurvers);
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {

    mockHttpData(FakeSurveysFactory.makeInvalidApiJson());

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () async {

    mockHttpError(HttpError.forbidden);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {


    mockHttpError(HttpError.notFound);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
  
  test('Should throw UnexpectedError if HttpClient returns 500', () async {

    mockHttpError(HttpError.serverError);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
  
}
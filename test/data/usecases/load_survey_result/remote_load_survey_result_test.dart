import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/domain/entities/entities.dart';
import 'package:practice/data/usecases/usecases.dart';
import 'package:practice/data/http/http.dart';

import '../../../infra/mocks/mocks.dart';

class HttpClientSpy extends Mock implements HttpClient {}
void main() {

  late HttpClient httpClient;
  late String url;
  late RemoteLoadSurveyResult sut;
  late Map surveyResult;
  late String surveyId;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteLoadSurveyResult(httpClient: httpClient, url: url);
    surveyId = faker.guid.guid();
  });

  When mockRequest() => when(() => (httpClient.request(url: any(named: 'url'), method: any(named: 'method'))));

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  void mockHttpData(Map data) {
    surveyResult = data;
    mockRequest().thenAnswer((_) async => data);
  }


  

  test('Should call HttpClient with correct values', () async {

    mockHttpData(ApiFactory.makeSurveyResultJson());
    
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => (httpClient.request(url: url, method: 'get'))).called(1);

  });

  test('Should return surveyResult on 200', () async {

    mockHttpData(ApiFactory.makeSurveyResultJson()); 

    final result = await sut.loadBySurvey(surveyId: surveyId);

    final mockSurvers = SurveyResultEntity(surveyId: surveyResult['surveyId'], question: surveyResult['question'], answers: [
      SurveyAnswerEntity(
        image: surveyResult['answers'][0]['image'], 
        answer: surveyResult['answers'][0]['answer'], 
        isCurrentAnswer: surveyResult['answers'][0]['isCurrentAccountAnswer'], 
        percent: surveyResult['answers'][0]['percent'],
      ),
      SurveyAnswerEntity(
        image: surveyResult['answers'][1]['image'], 
        answer: surveyResult['answers'][1]['answer'], 
        isCurrentAnswer: surveyResult['answers'][1]['isCurrentAccountAnswer'], 
        percent: surveyResult['answers'][1]['percent'],
      ),
    ]);

    expect(result, mockSurvers);
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {

    mockHttpData(ApiFactory.makeInvalidApiJson());

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () async {

    mockHttpError(HttpError.forbidden);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {


    mockHttpError(HttpError.notFound);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
  
  test('Should throw UnexpectedError if HttpClient returns 500', () async {

    mockHttpError(HttpError.serverError);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
  
}
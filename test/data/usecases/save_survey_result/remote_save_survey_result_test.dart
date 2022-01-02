import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/data/usecases/usecases.dart';
import 'package:practice/data/http/http.dart';

import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';


void main() {

  late HttpClientSpy httpClient;
  late String url;
  late RemoteSaveSurveyResult sut;
  late String answer;
  late Map surveyResult;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteSaveSurveyResult(httpClient: httpClient, url: url);
    answer = faker.lorem.sentence();
    surveyResult = ApiFactory.makeSurveyResultJson();

    httpClient.mockHttpData(surveyResult); 
  });

  test('Should call HttpClient with correct values', () async {

    httpClient.mockHttpData(surveyResult); 

    await sut.save(answer: answer);

    verify(() => (httpClient.request(url: url, method: 'put', body: {'answer' : answer}))).called(1);

  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () async {

    httpClient.mockHttpError(HttpError.forbidden);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {


    httpClient.mockHttpError(HttpError.notFound);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });
  
  test('Should throw UnexpectedError if HttpClient returns 500', () async {

    httpClient.mockHttpError(HttpError.serverError);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

    test('Should return surveyResult on 200', () async {

    final result = await sut.save(answer: answer);

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

    httpClient.mockHttpData(ApiFactory.makeInvalidApiJson());

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });
  
}
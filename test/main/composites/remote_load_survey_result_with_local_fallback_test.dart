import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/domain/entities/entities.dart';

import 'package:practice/data/usecases/usecases.dart';

import 'package:practice/main/composites/composites.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {}
class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {

  RemoteLoadSurveyResultWithLocalFallback sut;
  RemoteLoadSurveyResult remoteSpy;
  LocalLoadSurveyResult localSpy;

  String surveyId;
  SurveyResultEntity remoteResult;
  SurveyResultEntity localResult;

  SurveyResultEntity mockSurveyResult() => SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
            image: faker.internet.httpUrl(),
            answer: faker.lorem.sentence(),
            isCurrentAnswer: faker.randomGenerator.boolean(),
            percent: faker.randomGenerator.integer(100),
          ),
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            isCurrentAnswer: faker.randomGenerator.boolean(),
            percent: faker.randomGenerator.integer(100),
          ),
        ],
      );


  PostExpectation mockRemoteSurveyResultCall() => when(remoteSpy.loadBySurvey(surveyId: anyNamed('surveyId')));
  PostExpectation mockLocalSurveyResultCall() => when(localSpy.loadBySurvey(surveyId: anyNamed('surveyId')));


  void mockRemoteSurveyResultError(DomainError error) => mockRemoteSurveyResultCall().thenThrow(error);
  void mockLocalSurveyResultError() => mockLocalSurveyResultCall().thenThrow(DomainError.unexpected);

  void mockRemoteSurveyResult() {
    remoteResult = mockSurveyResult();
    mockRemoteSurveyResultCall().thenAnswer((_) async => remoteResult);
  }

  void mockLocalSurveyResult() {
    localResult = mockSurveyResult();
    mockLocalSurveyResultCall().thenAnswer((_) async => localResult);
  }

  setUp(() {
    remoteSpy = RemoteLoadSurveyResultSpy();
    localSpy = LocalLoadSurveyResultSpy();

    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remoteSpy, local: localSpy);

    surveyId = faker.guid.guid();

  });

  test('Should call remote LoadBySurvey with correct values', () async {

    await sut.loadBySurvey(surveyId: surveyId);

    verify(remoteSpy.loadBySurvey(surveyId: surveyId)).called(1);

  });

  test('Should call local save with remote data', () async {

    mockRemoteSurveyResult();

    await sut.loadBySurvey(surveyId: surveyId);

    verify(localSpy.save(surveyResult: remoteResult)).called(1);

  });

  test('Should return remote data', () async {

    mockRemoteSurveyResult();

    final result = await sut.loadBySurvey(surveyId: surveyId);

    expect(result, remoteResult);

  });

  test('Should rethrow if remote LoadBySurvey throws AccessDeniedError', () async {

    mockRemoteSurveyResultError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));

  });

  test('Should return local data', () async {
    
    mockLocalSurveyResult();
    mockRemoteSurveyResultError(DomainError.unexpected);

    final result = await sut.loadBySurvey(surveyId: surveyId);

    expect(result, localResult);

  });

  test('Should throw UnexpectedError if local load fails', () async {

    mockLocalSurveyResultError();
    mockRemoteSurveyResultError(DomainError.unexpected);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));

  });
  
}
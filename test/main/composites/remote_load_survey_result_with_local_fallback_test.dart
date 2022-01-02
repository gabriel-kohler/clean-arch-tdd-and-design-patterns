import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/domain/entities/entities.dart';

import 'package:practice/main/composites/composites.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/entity_factory.dart';

void main() {

  late RemoteLoadSurveyResultWithLocalFallback sut;
  late RemoteLoadSurveyResultSpy remoteSpy;
  late LocalLoadSurveyResultSpy localSpy;

  late String surveyId;
  late SurveyResultEntity remoteResult;
  late SurveyResultEntity localResult;

  setUp(() {
    remoteResult = EntityFactory.makeSurveyResultEntity();
    
    remoteSpy = RemoteLoadSurveyResultSpy();
    localSpy = LocalLoadSurveyResultSpy();

    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remoteSpy, local: localSpy);

    surveyId = faker.guid.guid();

    remoteSpy.mockRemoteSurveyResult(remoteResult);
    localSpy.mockLocalSurveyResult(localResult);

  });

  setUpAll(() {
    localResult = EntityFactory.makeSurveyResultEntity();
    registerFallbackValue(localResult);
  });

  test('Should call remote LoadBySurvey with correct values', () async {

    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => (remoteSpy.loadBySurvey(surveyId: surveyId))).called(1);

  });

  test('Should call local save with remote data', () async {

    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => (localSpy.save(surveyResult: remoteResult))).called(1);

  });

  test('Should return remote data', () async {

    final result = await sut.loadBySurvey(surveyId: surveyId);

    expect(result, remoteResult);

  });

  test('Should rethrow if remote LoadBySurvey throws AccessDeniedError', () async {

    remoteSpy.mockRemoteSurveyResultError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));

  });

  test('Should return local data', () async {
    
    remoteSpy.mockRemoteSurveyResultError(DomainError.unexpected);

    final result = await sut.loadBySurvey(surveyId: surveyId);

    expect(result, localResult);

  });

  test('Should throw UnexpectedError if local load fails', () async {

    remoteSpy.mockRemoteSurveyResultError(DomainError.unexpected);
    localSpy.mockLocalSurveyResultError(DomainError.unexpected);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));

  });
  
}
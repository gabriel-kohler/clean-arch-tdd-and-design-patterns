import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:practice/main/composites/composites.dart';

import 'package:practice/data/usecases/load_surveys/load_surveys.dart';

import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/domain/entities/entities.dart';


class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {

  RemoteLoadSurveys remoteLoadSurveysSpy;
  LocalLoadSurveys localLoadSurveysSpy;
  RemoteLoadSurveysWithLocalFallback sut;

  List<SurveyEntity> remoteSurveys;
  List<SurveyEntity> localSurveys;

  List<SurveyEntity> mockSurveys() {
    return [
      SurveyEntity(id: faker.guid.guid(), question: faker.randomGenerator.string(50), date: faker.date.dateTime(), didAnswer: faker.randomGenerator.boolean()),
      SurveyEntity(id: faker.guid.guid(), question: faker.randomGenerator.string(50), date: faker.date.dateTime(), didAnswer: faker.randomGenerator.boolean()),
    ];
  }

  PostExpectation mockRemoteLoadCall() => when(remoteLoadSurveysSpy.load());

  PostExpectation mockLocalLoadCall() => when(localLoadSurveysSpy.load());

  void mockRemoteLoad() {
    remoteSurveys = mockSurveys();
    mockRemoteLoadCall().thenAnswer((_) async => remoteSurveys);
  }

  void mockLocalLoad() {
    localSurveys = mockSurveys();
    mockLocalLoadCall().thenAnswer((_) async => localSurveys);
  }

  void mockRemoteLoadError(DomainError error) => mockRemoteLoadCall().thenThrow(error);

  void mockLocalLoadError() => mockLocalLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    remoteLoadSurveysSpy = RemoteLoadSurveysSpy();
    localLoadSurveysSpy = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remoteLoad: remoteLoadSurveysSpy, localLoad: localLoadSurveysSpy);

  });

  test('Should call remote load surveys', () async {
    
    await sut.load();

    verify(remoteLoadSurveysSpy.load()).called(1);
  });

  test('Should call local save with remote data', () async {

    mockRemoteLoad();

    await sut.load();

    verify(localLoadSurveysSpy.save(remoteSurveys)).called(1);
  });

  test('Should return remote data', () async {

    mockRemoteLoad();

    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });

  test('Should rethrow if remote load throws AccessDeniedError', () async {

    mockRemoteLoadError(DomainError.accessDenied);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {

    mockRemoteLoadError(DomainError.unexpected);

    await sut.load();

    verify(localLoadSurveysSpy.validate()).called(1);
    verify(localLoadSurveysSpy.load()).called(1);
  });

  test('Should return local data on remote error', () async {

    mockLocalLoad();

    mockRemoteLoadError(DomainError.unexpected);

    final surveys = await sut.load();

    expect(surveys, localSurveys);
  });

  test('Should throw UnexpectedError if remote and local throws', () async {

    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

}
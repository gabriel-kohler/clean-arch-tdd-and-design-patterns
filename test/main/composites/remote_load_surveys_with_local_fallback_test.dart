import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:practice/main/composites/composites.dart';

import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/domain/entities/entities.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {

  late RemoteLoadSurveysSpy remoteLoadSurveysSpy;
  late LocalLoadSurveysSpy localLoadSurveysSpy;
  late RemoteLoadSurveysWithLocalFallback sut;

  late List<SurveyEntity> remoteSurveys;
  late List<SurveyEntity> localSurveys;

  setUp(() {
    remoteLoadSurveysSpy = RemoteLoadSurveysSpy();
    localLoadSurveysSpy = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remoteLoad: remoteLoadSurveysSpy, localLoad: localLoadSurveysSpy);

    remoteSurveys = EntityFactory.makeSurveysList();
    localSurveys = EntityFactory.makeSurveysList();

  });

  test('Should call remote load surveys', () async {
    
    remoteLoadSurveysSpy.mockLoad(remoteSurveys);

    await sut.load();

    verify(() => (remoteLoadSurveysSpy.load())).called(1);
  });

  test('Should call local save with remote data', () async {

    remoteLoadSurveysSpy.mockLoad(remoteSurveys);

    await sut.load();

    verify(() => (localLoadSurveysSpy.save(remoteSurveys))).called(1);
  });

  test('Should return remote data', () async {

    remoteLoadSurveysSpy.mockLoad(remoteSurveys);

    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });

  test('Should rethrow if remote load throws AccessDeniedError', () async {

    remoteLoadSurveysSpy.mockLoadError(DomainError.accessDenied);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {

    localLoadSurveysSpy.mockLoad(localSurveys);
    remoteLoadSurveysSpy.mockLoadError(DomainError.unexpected);

    await sut.load();

    verify(() => (localLoadSurveysSpy.validate())).called(1);
    verify(() => (localLoadSurveysSpy.load())).called(1);
  });

  test('Should return local data on remote error', () async {

    localLoadSurveysSpy.mockLoad(localSurveys);
    remoteLoadSurveysSpy.mockLoadError(DomainError.unexpected);

    final surveys = await sut.load();

    expect(surveys, localSurveys);
  });

  test('Should throw UnexpectedError if remote and local throws', () async {

    localLoadSurveysSpy.mockLoadError();
    remoteLoadSurveysSpy.mockLoadError(DomainError.unexpected);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

}
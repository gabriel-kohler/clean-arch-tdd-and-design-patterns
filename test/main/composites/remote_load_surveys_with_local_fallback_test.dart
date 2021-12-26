import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/domain/helpers/domain_error.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:practice/data/usecases/load_surveys/load_surveys.dart';
import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/usecases/survey/load_surveys.dart';


class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {

  final RemoteLoadSurveys remoteLoad;
  final LocalLoadSurveys localLoad;

  RemoteLoadSurveysWithLocalFallback({@required this.remoteLoad, @required this.localLoad});

  Future<List<SurveyEntity>> load() async {
    final surveys = await remoteLoad.load();
    await localLoad.save(surveys);
    return surveys;
  }
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {

  RemoteLoadSurveys remoteLoadSurveysSpy;
  LocalLoadSurveys localLoadSurveysSpy;
  RemoteLoadSurveysWithLocalFallback sut;

  List<SurveyEntity> remoteSurveys;

  List<SurveyEntity> mockSurveys() {
    return [
      SurveyEntity(id: faker.guid.guid(), question: faker.randomGenerator.string(50), date: faker.date.dateTime(), didAnswer: faker.randomGenerator.boolean()),
      SurveyEntity(id: faker.guid.guid(), question: faker.randomGenerator.string(50), date: faker.date.dateTime(), didAnswer: faker.randomGenerator.boolean()),
    ];
  }

  PostExpectation mockRemoteLoadCall() => when(remoteLoadSurveysSpy.load());

  void mockRemoteLoad() {
    remoteSurveys = mockSurveys();
    mockRemoteLoadCall().thenAnswer((_) async => remoteSurveys);
  }

  void mockRemoteLoadError(DomainError error) => mockRemoteLoadCall().thenThrow(error);

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
}
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';
import 'package:practice/domain/entities/entities.dart';
import 'package:test/test.dart';

import 'package:practice/data/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback {

  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({@required this.remote, @required this.local});

  Future<void> loadBySurvey({String surveyId}) async {
    final result = await remote.loadBySurvey(surveyId: surveyId);
    await local.save(surveyId: surveyId, surveyResult: result);
  }

}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {}
class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {

  RemoteLoadSurveyResultWithLocalFallback sut;
  RemoteLoadSurveyResult remoteSpy;
  LocalLoadSurveyResult localSpy;

  String surveyId;
  SurveyResultEntity surveyResult;

  void mockSurveyResult() {

    surveyResult = SurveyResultEntity(
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
        ]);

    when(remoteSpy.loadBySurvey(surveyId: anyNamed('surveyId'))).thenAnswer((_) async => surveyResult);
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

    mockSurveyResult();

    await sut.loadBySurvey(surveyId: surveyId);

    verify(localSpy.save(surveyId: surveyId, surveyResult: surveyResult)).called(1);

  });
}
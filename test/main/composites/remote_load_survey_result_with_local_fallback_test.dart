import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

import 'package:practice/data/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback {

  final RemoteLoadSurveyResult remote;

  RemoteLoadSurveyResultWithLocalFallback({@required this.remote});

  Future<void> loadBySurvey({String surveyId}) async {
    await remote.loadBySurvey(surveyId: surveyId);
  }

}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {}

void main() {

  test('Should call remote LoadBySurvey', () async {
    final surveyId = faker.guid.guid();
    final remoteSpy = RemoteLoadSurveyResultSpy();
    final sut = RemoteLoadSurveyResultWithLocalFallback(remote: remoteSpy);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(remoteSpy.loadBySurvey(surveyId: surveyId)).called(1);

  });
}
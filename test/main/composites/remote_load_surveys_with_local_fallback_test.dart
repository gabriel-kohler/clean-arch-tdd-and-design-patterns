import 'package:mockito/mockito.dart';
import 'package:practice/data/usecases/load_surveys/load_surveys.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:practice/domain/usecases/survey/survey.dart';

class RemoteLoadSurveysWithLocalFallback {

  final LoadSurveys remoteLoad;

  RemoteLoadSurveysWithLocalFallback({@required this.remoteLoad});

  Future<void> load() async {
    await remoteLoad.load();
  }
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

void main() {

  test('Should call remote load surveys', () async {
    final remoteLoadSurveysSpy = RemoteLoadSurveysSpy();
    final sut = RemoteLoadSurveysWithLocalFallback(remoteLoad: remoteLoadSurveysSpy);

    await sut.load();

    verify(remoteLoadSurveysSpy.load()).called(1);
  });
}
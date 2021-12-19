import 'package:mockito/mockito.dart';
import 'package:practice/domain/usecases/survey/load_surveys.dart';
import 'package:test/test.dart';

import 'package:practice/presentation/presenters/presenters.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}
void main() {

  test('Should call LoadSurveys with correct values', () async {
    final loadSurveysSpy = LoadSurveysSpy();
    final sut = GetxSurveysPresenter(loadSurveys: loadSurveysSpy);

    await sut.loadData();

    verify(loadSurveysSpy.load()).called(1);

  });
}
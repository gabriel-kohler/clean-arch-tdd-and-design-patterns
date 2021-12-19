import 'package:mockito/mockito.dart';
import 'package:practice/domain/usecases/survey/load_surveys.dart';
import 'package:test/test.dart';

import 'package:practice/presentation/presenters/presenters.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}
void main() {
  LoadSurveys loadSurveysSpy;
  GetxSurveysPresenter sut;

  setUp(() {
    loadSurveysSpy = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveysSpy);
  });

  test('Should call LoadSurveys with correct values', () async {

    await sut.loadData();

    verify(loadSurveysSpy.load()).called(1);

  });

  test('Should present loading before call LoadSurveys and hide loading after LoadSurveys', () async {

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.loadData();

  });
}
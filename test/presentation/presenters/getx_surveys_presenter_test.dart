import 'package:mocktail/mocktail.dart';
import 'package:practice/domain/helpers/domain_error.dart';
import 'package:practice/ui/helpers/errors/errors.dart';
import 'package:practice/ui/pages/pages.dart';
import 'package:test/test.dart';

import 'package:practice/domain/entities/entities.dart';

import 'package:practice/presentation/presenters/presenters.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late LoadSurveysSpy loadSurveysSpy;
  late GetxSurveysPresenter sut;
  late List<SurveyEntity> surveys;


  setUp(() {
    loadSurveysSpy = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveysSpy);

    surveys = EntityFactory.makeSurveysList();

    loadSurveysSpy.mockLoad(surveys);
  });

  test('Should call LoadSurveys with correct values', () async {

    await sut.loadData();

    verify(() => (loadSurveysSpy.load())).called(1);

  });

  test('Should emit correct events on success', () async {

    sut.surveysStream.listen(
      expectAsync1((surveys) {
        expect(surveys, [
          SurveyViewModel(id: surveys[0].id, question: surveys[0].question, date: '19 Dec 2021', didAnswer: surveys[0].didAnswer),
          SurveyViewModel(id: surveys[1].id, question: surveys[1].question, date: '28 Apr 2021', didAnswer: surveys[1].didAnswer),
        ]);
      }),
    );

    await sut.loadData();

  });

  test('Should emit correct events on failure', () async {

    loadSurveysSpy.mockLoadError(DomainError.unexpected);

    sut.surveysStream.listen(
    null, 
    onError: expectAsync2((error, stack) {
        expect(error, UIError.unexpected.description);
      }),
    );

    await sut.loadData();

  });

  test('Should emit correct events on access denied', () async {

    loadSurveysSpy.mockLoadError(DomainError.accessDenied);

    expectLater(sut.isSessionExpiredStream, emits(true));
    
    await sut.loadData();

  });

  test('Should go to SurveyResultPage on link click', () async {
    
    expectLater(sut.navigateToStream, emitsInOrder([
      '/survey_result/1',
      '/survey_result/1',
    ]));

    sut.goToSurveyResult('1');
    sut.goToSurveyResult('1');

  });

}
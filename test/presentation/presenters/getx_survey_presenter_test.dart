import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/domain/helpers/domain_error.dart';
import 'package:practice/ui/helpers/errors/errors.dart';
import 'package:practice/ui/pages/pages.dart';
import 'package:test/test.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/usecases/survey/survey.dart';

import 'package:practice/presentation/presenters/presenters.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}
void main() {
  LoadSurveys loadSurveysSpy;
  GetxSurveysPresenter sut;
  List<SurveyEntity> surveys;

  List<SurveyEntity> mockValidData() => [
    SurveyEntity(id: faker.guid.guid(), question: faker.lorem.sentence(), date: DateTime(2021, 12, 19), didAnswer: true),
    SurveyEntity(id: faker.guid.guid(), question: faker.lorem.sentence(), date: DateTime(2021, 04, 28), didAnswer: false),
  ];

  PostExpectation mockLoadSurveysCall() => when(loadSurveysSpy.load());

  void mockLoadSurveys({List<SurveyEntity> data}) {
    surveys = data;
    mockLoadSurveysCall().thenAnswer((_) async => surveys);
  }

  void mockLoadSurveysError() => mockLoadSurveysCall().thenThrow(DomainError.unexpected);

  setUp(() {
    loadSurveysSpy = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveysSpy);
  });

  test('Should call LoadSurveys with correct values', () async {

    mockLoadSurveys(data: mockValidData());

    await sut.loadData();

    verify(loadSurveysSpy.load()).called(1);

  });

  test('Should emit correct events on success', () async {

    mockLoadSurveys(data: mockValidData());


    sut.surveysStream.listen(
      expectAsync1((surveys) {
        expect(surveys, [
          SurveyViewModel(id: surveys[0].id, question: surveys[0].question, date: '19 Dez 2021', didAnswer: surveys[0].didAnswer),
          SurveyViewModel(id: surveys[1].id, question: surveys[1].question, date: '28 Abr 2021', didAnswer: surveys[1].didAnswer),
        ]);
      }),
    );

    await sut.loadData();

  });

  test('Should emit correct events on failure', () async {

    mockLoadSurveysError();


    sut.surveysStream.listen(
    null, 
    onError: expectAsync2((error, stack) {
        expect(error, UIError.unexpected.description);
      }),
    );

    await sut.loadData();

  });

}
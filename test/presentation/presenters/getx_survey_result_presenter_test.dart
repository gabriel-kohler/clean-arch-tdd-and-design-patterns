import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/domain/helpers/domain_error.dart';
import 'package:practice/ui/helpers/errors/errors.dart';
import 'package:practice/ui/pages/pages.dart';
import 'package:test/test.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/usecases/survey/survey.dart';

import 'package:practice/presentation/presenters/presenters.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {}

void main() {
  LoadSurveyResult loadSurveyResultSpy;
  SaveSurveyResult saveSurveyResultSpy;

  GetxSurveyResultPresenter sut;
  SurveyResultEntity surveyResult;
  String surveyId;

  String answer;

  SurveyResultEntity mockValidData() => SurveyResultEntity(
    surveyId: faker.guid.guid(), 
    question: faker.lorem.sentence(), 
    answers: [
      SurveyAnswerEntity(
        image: faker.internet.httpUrl(),
        answer: faker.lorem.sentence(), 
        isCurrentAnswer: faker.randomGenerator.boolean(), 
        percent: faker.randomGenerator.integer(100)
      ),
      SurveyAnswerEntity(
        answer: faker.lorem.sentence(), 
        isCurrentAnswer: faker.randomGenerator.boolean(), 
        percent: faker.randomGenerator.integer(100)
      ),
    ]);

  PostExpectation mockLoadSurveyResultCall() => when(loadSurveyResultSpy.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLoadSurveyResult({SurveyResultEntity data}) {
    surveyResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => surveyResult);
  }

  void mockLoadSurveyResultError() => mockLoadSurveyResultCall().thenThrow(DomainError.unexpected);
  void mockLoadSurveyResultAccessDeniedError() => mockLoadSurveyResultCall().thenThrow(DomainError.accessDenied);

  setUp(() {
    surveyId = faker.guid.guid();

    loadSurveyResultSpy = LoadSurveyResultSpy();
    saveSurveyResultSpy = SaveSurveyResultSpy();

    sut = GetxSurveyResultPresenter(loadSurveyResult: loadSurveyResultSpy, saveSurveyResult: saveSurveyResultSpy, surveyId: surveyId);

    answer = faker.lorem.sentence();
  });

  group('loadData', () {
    test('Should call LoadSurveys with correct values', () async {

      mockLoadSurveyResult(data: mockValidData());

      await sut.loadData();

      verify(loadSurveyResultSpy.loadBySurvey(surveyId: surveyId)).called(1);

    });

    test('Should emit correct events on success', () async {

      mockLoadSurveyResult(data: mockValidData());

      sut.surveyResultStream.listen(
        expectAsync1((result) {
          expect(result, 
            SurveyResultViewModel(
              surveyId: surveyResult.surveyId, 
              question: surveyResult.question, 
              answers: [
                SurveyAnswerViewModel(
                  image: surveyResult.answers[0].image,
                  answer: surveyResult.answers[0].answer, 
                  isCurrentAnswer: surveyResult.answers[0].isCurrentAnswer, 
                  percent: '${surveyResult.answers[0].percent}%',
                ),
                SurveyAnswerViewModel(
                  answer: surveyResult.answers[1].answer, 
                  isCurrentAnswer: surveyResult.answers[1].isCurrentAnswer, 
                  percent: '${surveyResult.answers[1].percent}%',
                ),
              ],
            ),
          );
        }),
      );

      await sut.loadData();

    });

    test('Should emit correct events on failure', () async {

      mockLoadSurveyResultError();


      sut.surveyResultStream.listen(
      null, 
      onError: expectAsync2((error, stack) {
          expect(error, UIError.unexpected.description);
        }),
      );

      await sut.loadData();

    });

    test('Should emit correct events on access denied', () async {

      mockLoadSurveyResultAccessDeniedError();

      expectLater(sut.isSessionExpiredStream, emits(true));
      
      await sut.loadData();

    });

  });

  group('save', () {
    test('Should call SaveSurveyResult with correct values', () async {

      await sut.save(answer: answer);

      verify(saveSurveyResultSpy.save(answer: answer)).called(1);

    });
    
  });

}
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

  SurveyResultEntity loadResult;
  SurveyResultEntity saveResult;

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
    loadResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => loadResult);
  }

  void mockLoadSurveyResultError(DomainError error) => mockLoadSurveyResultCall().thenThrow(error);

  PostExpectation mockSaveSurveyResultCall() => when(saveSurveyResultSpy.save(answer: anyNamed('answer')));

  void mockSaveSurveyResult({SurveyResultEntity data}) {
    saveResult = data;
    mockSaveSurveyResultCall().thenAnswer((_) async => saveResult);
  }

  void mockSaveSurveyResultError(DomainError error) => mockSaveSurveyResultCall().thenThrow(error);

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
              surveyId: loadResult.surveyId, 
              question: loadResult.question, 
              answers: [
                SurveyAnswerViewModel(
                  image: loadResult.answers[0].image,
                  answer: loadResult.answers[0].answer, 
                  isCurrentAnswer: loadResult.answers[0].isCurrentAnswer, 
                  percent: '${loadResult.answers[0].percent}%',
                ),
                SurveyAnswerViewModel(
                  answer: loadResult.answers[1].answer, 
                  isCurrentAnswer: loadResult.answers[1].isCurrentAnswer, 
                  percent: '${loadResult.answers[1].percent}%',
                ),
              ],
            ),
          );
        }),
      );

      await sut.loadData();

    });

    test('Should emit correct events on failure', () async {

      mockLoadSurveyResultError(DomainError.unexpected);


      sut.surveyResultStream.listen(
      null, 
      onError: expectAsync2((error, stack) {
          expect(error, UIError.unexpected.description);
        }),
      );

      await sut.loadData();

    });

    test('Should emit correct events on access denied', () async {

      mockLoadSurveyResultError(DomainError.accessDenied);

      expectLater(sut.isSessionExpiredStream, emits(true));
      
      await sut.loadData();

    });

  });

  group('save', () {
    test('Should call SaveSurveyResult with correct values', () async {

      mockSaveSurveyResult(data: mockValidData());

      await sut.save(answer: answer);

      verify(saveSurveyResultSpy.save(answer: answer)).called(1);

    });

    test('Should emit correct events on success', () async {

      mockSaveSurveyResult(data: mockValidData());

      sut.surveyResultStream.listen(
        expectAsync1((result) {
          expect(result, 
            SurveyResultViewModel(
              surveyId: saveResult.surveyId, 
              question: saveResult.question, 
              answers: [
                SurveyAnswerViewModel(
                  image: saveResult.answers[0].image,
                  answer: saveResult.answers[0].answer, 
                  isCurrentAnswer: saveResult.answers[0].isCurrentAnswer, 
                  percent: '${saveResult.answers[0].percent}%',
                ),
                SurveyAnswerViewModel(
                  answer: saveResult.answers[1].answer, 
                  isCurrentAnswer: saveResult.answers[1].isCurrentAnswer, 
                  percent: '${saveResult.answers[1].percent}%',
                ),
              ], 
            ),
          );
        }),
      );

      await sut.save(answer: answer);

    });

    test('Should emit correct events on failure', () async {

      mockSaveSurveyResultError(DomainError.unexpected);

      sut.surveyResultStream.listen(
      null, 
      onError: expectAsync2((error, stack) {
          expect(error, UIError.unexpected.description);
        }),
      );

      await sut.save(answer: answer);

    });

    test('Should emit correct events on access denied', () async {

      mockSaveSurveyResultError(DomainError.accessDenied);

      expectLater(sut.isSessionExpiredStream, emits(true));
      
      await sut.save(answer: answer);

    });
    
  });

}
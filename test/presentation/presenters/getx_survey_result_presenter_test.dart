import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice/domain/helpers/domain_error.dart';
import 'package:practice/ui/helpers/errors/errors.dart';
import 'package:practice/ui/pages/pages.dart';
import 'package:test/test.dart';

import 'package:practice/domain/entities/entities.dart';

import 'package:practice/presentation/presenters/presenters.dart';

import '../../domain/mocks/mocks.dart';

void main() {
  late LoadSurveyResultSpy loadSurveyResultSpy;
  late SaveSurveyResultSpy saveSurveyResultSpy;

  late GetxSurveyResultPresenter sut;

  late SurveyResultEntity loadResult;
  late SurveyResultEntity saveResult;

  late String surveyId;

  late String answer;

  SurveyResultViewModel mapToViewModel(SurveyResultEntity entity) {
    return SurveyResultViewModel(
              surveyId: entity.surveyId, 
              question: entity.question, 
              answers: [
                SurveyAnswerViewModel(
                  image: entity.answers[0].image,
                  answer: entity.answers[0].answer, 
                  isCurrentAnswer: entity.answers[0].isCurrentAnswer, 
                  percent: '${entity.answers[0].percent}%',
                ),
                SurveyAnswerViewModel(
                  answer: entity.answers[1].answer, 
                  isCurrentAnswer: entity.answers[1].isCurrentAnswer, 
                  percent: '${entity.answers[1].percent}%',
                ),
              ], 
            );
  }

  setUp(() {
    surveyId = faker.guid.guid();

    loadSurveyResultSpy = LoadSurveyResultSpy();
    saveSurveyResultSpy = SaveSurveyResultSpy();

    sut = GetxSurveyResultPresenter(loadSurveyResult: loadSurveyResultSpy, saveSurveyResult: saveSurveyResultSpy, surveyId: surveyId);

    loadResult = EntityFactory.makeSurveyResultEntity();
    saveResult = EntityFactory.makeSurveyResultEntity();

    answer = faker.lorem.sentence();

    loadSurveyResultSpy.mockLoadSurveyResult(loadResult);
    saveSurveyResultSpy.mockSaveSurveyResult(saveResult);
  });

  group('loadData', () {
    test('Should call LoadSurveys with correct values', () async {
      
      await sut.loadData();

      verify(() => (loadSurveyResultSpy.loadBySurvey(surveyId: surveyId))).called(1);

    });

    test('Should emit correct events on success', () async {

      sut.surveyResultStream.listen(
        expectAsync1((result) {
          expect(result, mapToViewModel(loadResult),
          );
        }),
      );

      await sut.loadData();

    });

    test('Should emit correct events on failure', () async {

      loadSurveyResultSpy.mockLoadSurveyResultError(DomainError.unexpected);

      sut.surveyResultStream.listen(
      null, 
      onError: expectAsync2((error, stack) {
          expect(error, UIError.unexpected.description);
        }),
      );

      await sut.loadData();

    });

    test('Should emit correct events on access denied', () async {

      loadSurveyResultSpy.mockLoadSurveyResultError(DomainError.accessDenied);

      expectLater(sut.isSessionExpiredStream, emits(true));
      
      await sut.loadData();

    });

  });

  group('save', () {
    test('Should call SaveSurveyResult with correct values', () async {

      await sut.save(answer: answer);

      verify(() => (saveSurveyResultSpy.save(answer: answer))).called(1);

    });

    test('Should emit correct events on success', () async {

      expectLater(sut.surveyResultStream, emitsInOrder([
        mapToViewModel(loadResult),
        mapToViewModel(saveResult),
      ]));


      await sut.loadData();
      await sut.save(answer: answer);

    });

    test('Should emit correct events on failure', () async {

      saveSurveyResultSpy.mockSaveSurveyResultError(DomainError.unexpected);

      sut.surveyResultStream.listen(
      null, 
      onError: expectAsync2((error, stack) {
          expect(error, UIError.unexpected.description);
        }),
      );

      await sut.save(answer: answer);

    });

    test('Should emit correct events on access denied', () async {

      saveSurveyResultSpy.mockSaveSurveyResultError(DomainError.accessDenied);

      expectLater(sut.isSessionExpiredStream, emits(true));
      
      await sut.save(answer: answer);

    });
    
  });

}
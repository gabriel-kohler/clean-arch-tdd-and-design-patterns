import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:practice/domain/helpers/domain_error.dart';
import 'package:practice/domain/entities/entities.dart';

import 'package:practice/data/usecases/usecases.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {

  late CacheStorageSpy cacheStorageSpy;
  late LocalLoadSurveyResult sut;

  late Map listData;
  late String surveyId;
  late SurveyResultEntity surveyResult;

  setUp(() {
    cacheStorageSpy = CacheStorageSpy();
    sut = LocalLoadSurveyResult(cacheStorage: cacheStorageSpy);
    surveyId = faker.guid.guid();
    listData = CacheFactory.makeCacheJson();
    cacheStorageSpy.mockFetchData(listData);
    surveyResult = EntityFactory.makeSurveyResultEntity();
  });
  group('loadBySurvey', () {

    test('Should call FetchCacheStorage with correct key', () async {
    
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => (cacheStorageSpy.fetch(key: 'survey_result/$surveyId'))).called(1);

    });

    test('Should return a list of surveyResult on success', () async {
      
      final surveys = await sut.loadBySurvey(surveyId: surveyId);

      final mockSurvers = SurveyResultEntity(
        surveyId: listData['surveyId'],
        question: listData['question'],
        answers: [
          SurveyAnswerEntity(
            image: listData['answers'][0]['image'],
            answer: listData['answers'][0]['answer'], 
            isCurrentAnswer: true, 
            percent: 40,
          ),
          SurveyAnswerEntity(
            image: listData['answers'][1]['image'],
            answer: listData['answers'][1]['answer'], 
            isCurrentAnswer: false, 
            percent: 60,
          ),
        ]
      );
      
      expect(surveys, mockSurvers);

    });

  test('Should throw UnexpectedError if cache is empty', () async {
    
      cacheStorageSpy.mockFetchData({});

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));

    });

    test('Should throw UnexpectedError if cache is invalid', () async {
    
      cacheStorageSpy.mockFetchData(CacheFactory.makeInvalidSurveyResult());

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));

  });

    test('Should throw UnexpectedError if cache is incomplete', () async {
    
      cacheStorageSpy.mockFetchData(CacheFactory.makeIncompleteSurveyResult());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));

    });

    test('Should throw UnexpectedError if cache throws', () async {
    
      cacheStorageSpy.mockFetchError();

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));

    });
  });

  group('validate', () {
    test('Should call CacheStorage with correct key', () async {
    
    cacheStorageSpy.mockFetchData(CacheFactory.makeCacheJson());

    await sut.validate(surveyId: surveyId);

    verify(() => (cacheStorageSpy.fetch(key: 'survey_result/$surveyId'))).called(1);

    });

    test('Should delete cache if it is invalid', () async {
    
    cacheStorageSpy.mockFetchData(CacheFactory.makeInvalidSurveyResult());

    await sut.validate(surveyId: surveyId);

    verify(() => (cacheStorageSpy.delete(key: 'survey_result/$surveyId'))).called(1);

    });

    test('Should delete cache if it is incomplete', () async {
    
    cacheStorageSpy.mockFetchData(CacheFactory.makeIncompleteSurveyResult());

    await sut.validate(surveyId: surveyId);

    verify(() => (cacheStorageSpy.delete(key: 'survey_result/$surveyId'))).called(1);

    });

    test('Should delete cache if validate throws', () async {
    
    cacheStorageSpy.mockFetchError();

    await sut.validate(surveyId: surveyId);

    verify(() => (cacheStorageSpy.delete(key: 'survey_result/$surveyId'))).called(1);

    });


  });

  group('save', () {
    test('Should call CacheStorage with correct values', () async {
    
    Map json = {
      'surveyId': surveyResult.surveyId,
      'question': surveyResult.question,
      'answers': [
        {
        'image': surveyResult.answers[0].image,
        'answer': surveyResult.answers[0].answer,
        'isCurrentAnswer': 'true',
        'percent': '40',
        },
        {
        'image': null,
        'answer': surveyResult.answers[1].answer,
        'isCurrentAnswer': 'false',
        'percent': '60',
        },
      ],
    };
    
    await sut.save(surveyResult: surveyResult);

    verify(() => (cacheStorageSpy.save(key: 'survey_result/${surveyResult.surveyId}', value: json))).called(1);

    });
    
    test('Should LocalLoadSurveys throw UnexpectedError if save throws', () async {

      cacheStorageSpy.mockSaveError();

      final future = sut.save(surveyResult: surveyResult);

      expect(future, throwsA(DomainError.unexpected));

    });

  });

}
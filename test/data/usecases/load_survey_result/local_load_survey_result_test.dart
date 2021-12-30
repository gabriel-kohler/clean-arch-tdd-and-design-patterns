import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:practice/domain/helpers/domain_error.dart';
import 'package:practice/domain/entities/entities.dart';

import 'package:practice/data/usecases/usecases.dart';
import 'package:practice/data/cache/cache.dart';

import '../../../mocks/mocks.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {

  

  group('loadBySurvey', () {

    CacheStorage cacheStorageSpy;
    LocalLoadSurveyResult sut;

    Map listData;
    String surveyId;

    PostExpectation mockFetchCall() => when(cacheStorageSpy.fetch(key: anyNamed('key')));

    void mockFetchData(Map json) {
      listData = json;
      mockFetchCall().thenAnswer((_) async => listData);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());


    setUp(() {
      cacheStorageSpy = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorageSpy);
      surveyId = faker.guid.guid();
    });
    test('Should call FetchCacheStorage with correct key', () async {
    
    mockFetchData(FakeSurveyResultFactory.makeCacheJson());

    await sut.loadBySurvey(surveyId: surveyId);

    verify(cacheStorageSpy.fetch(key: 'survey_result/$surveyId')).called(1);

    });

    test('Should return a list of surveyResult on success', () async {
      
      mockFetchData(FakeSurveyResultFactory.makeCacheJson());

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
    
      mockFetchData({});

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));

    });

    test('Should throw UnexpectedError if cache is null', () async {
    
      mockFetchData(null);

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));

    });

    test('Should throw UnexpectedError if cache is invalid', () async {
    
      mockFetchData(FakeSurveyResultFactory.makeInvalidCacheJson());

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));

  });

    test('Should throw UnexpectedError if cache is incomplete', () async {
    
      mockFetchData(FakeSurveyResultFactory.makeIncompleteCacheJson());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));

    });

    test('Should throw UnexpectedError if cache throws', () async {
    
      mockFetchError();

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));

    });
  });

  group('validate', () {

    CacheStorage cacheStorageSpy;
    LocalLoadSurveyResult sut;

    Map listData;
    String surveyId;


    PostExpectation mockFetchCall() => when(cacheStorageSpy.fetch(key: anyNamed('key')));

    void mockFetchData(Map json) {
      listData = json;
     mockFetchCall().thenAnswer((_) async => listData);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    
    setUp(() {
      cacheStorageSpy = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorageSpy);
      surveyId = faker.guid.guid();
    });
    test('Should call CacheStorage with correct key', () async {
    
    mockFetchData(FakeSurveyResultFactory.makeCacheJson());

    await sut.validate(surveyId: surveyId);

    verify(cacheStorageSpy.fetch(key: 'survey_result/$surveyId')).called(1);

    });

    test('Should delete cache if it is invalid', () async {
    
    mockFetchData(FakeSurveyResultFactory.makeInvalidCacheJson());

    await sut.validate(surveyId: surveyId);

    verify(cacheStorageSpy.delete(key: 'survey_result/$surveyId')).called(1);

    });

    test('Should delete cache if it is incomplete', () async {
    
    mockFetchData(FakeSurveyResultFactory.makeIncompleteCacheJson());

    await sut.validate(surveyId: surveyId);

    verify(cacheStorageSpy.delete(key: 'survey_result/$surveyId')).called(1);

    });

    test('Should delete cache if validate throws', () async {
    
    mockFetchError();

    await sut.validate(surveyId: surveyId);

    verify(cacheStorageSpy.delete(key: 'survey_result/$surveyId')).called(1);

    });


  });

  group('save', () {

    CacheStorage cacheStorageSpy;
    LocalLoadSurveyResult sut;
    SurveyResultEntity surveyResult;

    

    
    PostExpectation mockSaveCall() => when(cacheStorageSpy.save(key: anyNamed('key'), value: anyNamed('value')));

    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      cacheStorageSpy = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorageSpy);
      surveyResult = FakeSurveyResultFactory.makeSurveyResultEntity();
    });


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

    verify(cacheStorageSpy.save(key: 'survey_result/${surveyResult.surveyId}', value: json)).called(1);

    });
    
    test('Should LocalLoadSurveys throw UnexpectedError if save throws', () async {

      mockSaveError();

      final future = sut.save(surveyResult: surveyResult);

      expect(future, throwsA(DomainError.unexpected));

    });

  });

}
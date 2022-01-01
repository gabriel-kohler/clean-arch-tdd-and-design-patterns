import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:practice/domain/helpers/domain_error.dart';
import 'package:practice/domain/entities/entities.dart';

import 'package:practice/data/usecases/usecases.dart';
import 'package:practice/data/cache/cache.dart';

import '../../../mocks/mocks.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {

  

  group('load', () {

    CacheStorage cacheStorageSpy;
    LocalLoadSurveys sut;

    List<Map> listData;

    PostExpectation mockFetchCall() => when(cacheStorageSpy.fetch(key: anyNamed('key')));

    void mockFetchData(List<Map> data) {
      listData = data;
     mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorageSpy = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorageSpy);
    });
    test('Should call FetchCacheStorage with correct key', () async {
    
    mockFetchData(FakeSurveysFactory.makeCacheJson());

    await sut.load();

    verify(cacheStorageSpy.fetch(key: 'surveys')).called(1);

    });

    test('Should return a list of surveys on success', () async {
      
      mockFetchData(FakeSurveysFactory.makeCacheJson());

      final surveys = await sut.load();


      final mockSurveys = [
        SurveyEntity(id: listData[0]['id'], question: listData[0]['question'], date: DateTime.utc(2021, 9, 20), didAnswer: false),
        SurveyEntity(id: listData[1]['id'], question: listData[1]['question'], date: DateTime.utc(2020, 2, 18), didAnswer: true),
        ];


      expect(surveys, mockSurveys);

    });

  test('Should throw UnexpectedError if cache is empty', () async {
    
      mockFetchData([]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));

    });

    test('Should throw UnexpectedError if cache is null', () async {
    
      mockFetchData(null);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));

    });

    test('Should throw UnexpectedError if cache is invalid', () async {
    
      mockFetchData(FakeSurveysFactory.makeInvalidCacheJson());

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));

  });

    test('Should throw UnexpectedError if cache is incomplete', () async {
    
      mockFetchData(FakeSurveysFactory.makeIncompleteCacheJson());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));

    });

    test('Should throw UnexpectedError if fetch fails', () async {
    
      mockFetchError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));

    });
  });

  group('validate', () {

    CacheStorage cacheStorageSpy;
    LocalLoadSurveys sut;

    List<Map> listData;


    PostExpectation mockFetchCall() => when(cacheStorageSpy.fetch(key: anyNamed('key')));

    void mockFetchData(List<Map> data) {
      listData = data;
     mockFetchCall().thenAnswer((_) async => listData);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());


    setUp(() {
      cacheStorageSpy = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorageSpy);
    });
    test('Should call CacheStorage with correct key', () async {
    
    mockFetchData(FakeSurveysFactory.makeCacheJson());

    await sut.validate();

    verify(cacheStorageSpy.fetch(key: 'surveys')).called(1);

    });

    test('Should delete cache if it is invalid', () async {
    
    mockFetchData(FakeSurveysFactory.makeInvalidCacheJson());

    await sut.validate();

    verify(cacheStorageSpy.delete(key: 'surveys')).called(1);

    });

    test('Should delete cache if it is incomplete', () async {
    
    mockFetchData(FakeSurveysFactory.makeIncompleteCacheJson());

    await sut.validate();

    verify(cacheStorageSpy.delete(key: 'surveys')).called(1);

    });

    test('Should delete cache if validate throws', () async {
    
    mockFetchError();

    await sut.validate();

    verify(cacheStorageSpy.delete(key: 'surveys')).called(1);

    });


  });

  group('save', () {

    CacheStorage cacheStorageSpy;
    LocalLoadSurveys sut;
    List<SurveyEntity> surveys;

    

    setUp(() {
      cacheStorageSpy = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorageSpy);

      surveys = FakeSurveysFactory.makeSurveyEntity();
    });

    PostExpectation mockSaveCall() => when(cacheStorageSpy.save(key: anyNamed('key'), value: anyNamed('value')));

    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    test('Should call CacheStorage with correct values', () async {
    
    final list = [
      {
        'id': surveys[0].id,
        'question': surveys[0].question,
        'date': '2021-12-19T00:00:00.000Z',
        'didAnswer': 'true',
      },
      {
      'id': surveys[1].id,
      'question': surveys[1].question,
      'date': '2021-04-28T00:00:00.000Z',
      'didAnswer': 'false',
      },
    ];

    await sut.save(surveys);

    verify(cacheStorageSpy.save(key: 'surveys', value: list)).called(1);

    });
    
    test('Should LocalLoadSurveys throw UnexpectedError if save throws', () async {

      mockSaveError();

      final future = sut.save(surveys);

      expect(future, throwsA(DomainError.unexpected));

    });

  });

}
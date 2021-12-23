import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:practice/domain/helpers/domain_error.dart';
import 'package:practice/domain/entities/entities.dart';

import 'package:practice/data/usecases/usecases.dart';
import 'package:practice/data/cache/cache.dart';

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

void main() {

  FetchCacheStorage fetchCacheStorageSpy;
  LocalLoadSurveys sut;

  List<Map> listData;

  PostExpectation mockFetchCall() => when(fetchCacheStorageSpy.fetch(key: anyNamed('key')));

  void mockFetchData(List<Map> data) {
    listData = data;
    mockFetchCall().thenAnswer((_) async => data);
  }

  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  List<Map> mockValidData() => [
    {
    'id': faker.guid.guid(),
    'question': faker.randomGenerator.string(10),
    'date': '2021-09-20T00:00:00Z', 
    'didAnswer': 'false',
    },
    {
    'id': faker.guid.guid(),
    'question': faker.randomGenerator.string(10),
    'date': '2020-02-18T00:00:00Z',
    'didAnswer': 'true',
    },
  ];


  setUp(() {
    fetchCacheStorageSpy = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorageSpy);

  });

  test('Should call FetchCacheStorage with correct key', () async {
    
    mockFetchData(mockValidData());

    await sut.load();

    verify(fetchCacheStorageSpy.fetch(key: 'surveys')).called(1);

  });

  test('Should return a list of surveys on success', () async {
    
    mockFetchData(mockValidData());

    final surveys = await sut.load();

    final mockSurvers = [
      SurveyEntity(id: listData[0]['id'], question: listData[0]['question'], date: DateTime.utc(2021, 9, 20), didAnswer: false),
      SurveyEntity(id: listData[1]['id'], question: listData[1]['question'], date: DateTime.utc(2020, 2, 18), didAnswer: true),
    ];

    expect(surveys, mockSurvers);

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
    
    mockFetchData([{
    'id': faker.guid.guid(),
    'question': faker.randomGenerator.string(10),
    'date': 'invalid_date', 
    'didAnswer': 'false',
    }]);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));

  });

  test('Should throw UnexpectedError if cache is incomplete', () async {
    
    mockFetchData([{
    'date': '2020-02-18T00:00:00Z',
    'didAnswer': 'true',
    }]);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));

  });

  test('Should throw UnexpectedError if fetch fails', () async {
    
    mockFetchError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));

  });

}
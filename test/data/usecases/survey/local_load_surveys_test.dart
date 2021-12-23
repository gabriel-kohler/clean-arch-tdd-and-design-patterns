import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/domain/helpers/domain_error.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:practice/data/models/local_survey_model.dart';
import 'package:practice/domain/entities/entities.dart';

abstract class FetchCacheStorage {
  Future<dynamic> fetch({@required key});
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({@required this.fetchCacheStorage});

  Future<List<SurveyEntity>> load() async {
    final List<dynamic> surveys = await fetchCacheStorage.fetch(key: 'surveys');
    if (surveys?.isEmpty != false) {
      throw DomainError.unexpected;
    }
    return surveys.map<SurveyEntity>((survey) => LocalSurveyModel.fromJson(survey).toSurveyEntity()).toList();
  }
}

void main() {

  FetchCacheStorage fetchCacheStorageSpy;
  LocalLoadSurveys sut;

  List<Map> listData;

  PostExpectation mockFetchResponse() => when(fetchCacheStorageSpy.fetch(key: anyNamed('key')));

  mockFetchData(List<Map> data) {
    listData = data;
    mockFetchResponse().thenAnswer((_) async => data);
  }

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

}
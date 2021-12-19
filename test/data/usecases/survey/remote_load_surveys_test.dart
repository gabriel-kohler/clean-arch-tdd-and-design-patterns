import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/data/models/remote_survey_model.dart';
import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/helpers/helpers.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:practice/domain/usecases/usecases.dart';
import 'package:practice/data/http/http.dart';


class RemoteLoadSurveys implements LoadSurveys {

  final HttpClient httpClient;
  final String url;

  RemoteLoadSurveys({@required this.httpClient, @required this.url});

  Future<List<SurveyEntity>> load() async {

    try {
      final List<Map> response = await httpClient.request(url: url, method: 'get');
      return response.map((json) => RemoteSurveyModel.fromJson(json).toSurveyEntity()).toList();
    } on HttpError {
      throw DomainError.unexpected; 
    }
    
    
  }

}

class HttpClientSpy extends Mock implements HttpClient {}
void main() {

  HttpClient httpClient;
  String url;
  RemoteLoadSurveys sut;
  List<Map> listData;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteLoadSurveys(httpClient: httpClient, url: url);
  });

  PostExpectation mockRequest() => when(httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpData(List<Map> data) {
    listData = data;
    mockRequest().thenAnswer((_) async => data);
  }

  List<Map> mockValidData() => [
    {
    'id': faker.guid.guid(),
    'question': faker.randomGenerator.string(10),
    'date': faker.date.dateTime().toIso8601String(),
    'didAnswer': false,
    },
    {
    'id': faker.guid.guid(),
    'question': faker.randomGenerator.string(10),
    'date': faker.date.dateTime().toIso8601String(),
    'didAnswer': false,
    },
  ];

  test('Should call HttpClient with correct values', () async {

    mockHttpData(mockValidData());
    
    await sut.load();

    verify(httpClient.request(url: url, method: 'get')).called(1);

  });

  test('Should return surveys on 200', () async {

    mockHttpData(mockValidData()); 

    final listSurveys = await sut.load();

    final mockSurvers = [
      SurveyEntity(id: listData[0]['id'], question: listData[0]['question'], date: DateTime.parse(listData[0]['date']), didAnswer: listData[0]['didAnswer']),
      SurveyEntity(id: listData[1]['id'], question: listData[1]['question'], date: DateTime.parse(listData[1]['date']), didAnswer: listData[1]['didAnswer']),
    ];

    expect(listSurveys, mockSurvers);
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {

    mockHttpData([{'invalid_key' : 'invalid_value'}]);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
  
}
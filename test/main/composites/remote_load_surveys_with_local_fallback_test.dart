import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/data/usecases/load_surveys/load_surveys.dart';
import 'package:practice/domain/entities/entities.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';


class RemoteLoadSurveysWithLocalFallback {

  final RemoteLoadSurveys remoteLoad;
  final LocalLoadSurveys localLoad;

  RemoteLoadSurveysWithLocalFallback({@required this.remoteLoad, @required this.localLoad});

  Future<List<SurveyEntity>> load() async {
    final surveys = await remoteLoad.load();
    await localLoad.save(surveys);
  }
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {

  RemoteLoadSurveys remoteLoadSurveysSpy;
  LocalLoadSurveys localLoadSurveysSpy;
  RemoteLoadSurveysWithLocalFallback sut;

  List<SurveyEntity> surveys;

  List<SurveyEntity> mockSurveys() {
    return [
      SurveyEntity(id: faker.guid.guid(), question: faker.randomGenerator.string(50), date: faker.date.dateTime(), didAnswer: faker.randomGenerator.boolean()),
      SurveyEntity(id: faker.guid.guid(), question: faker.randomGenerator.string(50), date: faker.date.dateTime(), didAnswer: faker.randomGenerator.boolean()),
    ];
  }

  void mockRemoteLoad() {
    surveys = mockSurveys();
    when(remoteLoadSurveysSpy.load()).thenAnswer((_) async => surveys);
  }

  setUp(() {
    remoteLoadSurveysSpy = RemoteLoadSurveysSpy();
    localLoadSurveysSpy = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remoteLoad: remoteLoadSurveysSpy, localLoad: localLoadSurveysSpy);

  });

  test('Should call remote load surveys', () async {
    
    await sut.load();

    verify(remoteLoadSurveysSpy.load()).called(1);
  });

  test('Should call local save with remote data', () async {

    mockRemoteLoad();

    await sut.load();

    verify(localLoadSurveysSpy.save(surveys)).called(1);
  });
}
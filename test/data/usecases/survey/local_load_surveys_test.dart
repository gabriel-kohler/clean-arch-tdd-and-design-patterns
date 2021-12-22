import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

abstract class FetchCacheStorage {
  Future<void> fetch({@required key});
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({@required this.fetchCacheStorage});

  Future<void> load() async {
    await fetchCacheStorage.fetch(key: 'surveys');
  }
}

void main() {

  FetchCacheStorage fetchCacheStorageSpy;
  LocalLoadSurveys sut;

  setUp(() {
    fetchCacheStorageSpy = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorageSpy);
  });
  test('Should call FetchCacheStorage with correct key', () async {
    

    await sut.load();

    verify(fetchCacheStorageSpy.fetch(key: 'surveys')).called(1);

  });
}
import 'package:practice/data/cache/cache.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

class AuthorizeHttpClientDecorator {
  final FetchSecureCurrentAccount fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({@required this.fetchSecureCacheStorage});

  Future<void> request() async {
    await fetchSecureCacheStorage.fetchSecure(key: 'token');
  }


}

class FetchSecureCacheSpy extends Mock implements FetchSecureCurrentAccount {}

void main() {
  FetchSecureCurrentAccount fetchSecureCacheSpy;
  AuthorizeHttpClientDecorator sut;

  setUp(() {
    fetchSecureCacheSpy = FetchSecureCacheSpy();
    sut = AuthorizeHttpClientDecorator(fetchSecureCacheStorage: fetchSecureCacheSpy);
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    
    await sut.request();

    verify(fetchSecureCacheSpy.fetchSecure(key: 'token')).called(1);

  });
}
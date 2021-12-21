import 'package:faker/faker.dart';
import 'package:practice/data/cache/cache.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

class AuthorizeHttpClientDecorator {
  final FetchSecureCurrentAccount fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({@required this.fetchSecureCacheStorage});

  Future<void> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    await fetchSecureCacheStorage.fetchSecure(key: 'token');
  }


}

class FetchSecureCacheSpy extends Mock implements FetchSecureCurrentAccount {}

void main() {
  FetchSecureCurrentAccount fetchSecureCacheSpy;
  AuthorizeHttpClientDecorator sut;

  String url;
  String method;
  Map body;

  setUp(() {
    fetchSecureCacheSpy = FetchSecureCacheSpy();
    sut = AuthorizeHttpClientDecorator(fetchSecureCacheStorage: fetchSecureCacheSpy);

    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key' : 'any_value'};
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    
    await sut.request(url: url, method: method, body: body);

    verify(fetchSecureCacheSpy.fetchSecure(key: 'token')).called(1);

  });

}
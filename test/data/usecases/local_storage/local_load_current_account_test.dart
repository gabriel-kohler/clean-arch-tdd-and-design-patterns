import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:practice/domain/entities/account_entity.dart';
import 'package:practice/domain/helpers/domain_error.dart';

import 'package:practice/data/cache/cache.dart';
import 'package:practice/data/usecases/usecases.dart';


class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

void main() {

  FetchSecureCacheStorage fetchSecureCacheStorageSpy;
  LocalLoadCurrentAccount sut;
  String token;

  setUp(() {
    fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorageSpy);
    token = faker.guid.guid();

  });

  mockFetchSecureCall() => when(fetchSecureCacheStorageSpy.fetchSecure(key: anyNamed('key')));

  mockFetchSecure() => mockFetchSecureCall().thenAnswer((_) async => token);

  mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

  test('Should call FetchSecureCacheStorage with correct values', () async {

    await sut.fetch();

    verify(fetchSecureCacheStorageSpy.fetchSecure(key: 'token')).called(1);

  });

  test('Should return AccountEntity if FetchSecure success', () async {

    mockFetchSecure();

    final account = await sut.fetch();

    expect(account, AccountEntity(token));
  });

  test('Should LocalLoadCurrentAccount throw UnexpectedError if FetchSecure throws', () async {

    mockFetchSecureError();

    final future = sut.fetch ();

    expect(future, throwsA(DomainError.unexpected));
    
  });

}
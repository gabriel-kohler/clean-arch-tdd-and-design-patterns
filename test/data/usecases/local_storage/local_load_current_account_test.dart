import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:practice/domain/entities/account_entity.dart';
import 'package:practice/domain/helpers/domain_error.dart';

import 'package:practice/data/usecases/usecases.dart';

import '../../mocks/mocks.dart';


void main() {

  late SecureCacheStorageSpy fetchSecureCacheStorageSpy;
  late LocalLoadCurrentAccount sut;
  late String token;

  setUp(() {
    fetchSecureCacheStorageSpy = SecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorageSpy);
    token = faker.guid.guid();

  });

  test('Should call FetchSecureCacheStorage with correct values', () async {

    fetchSecureCacheStorageSpy.mockFetchSecure(token);

    await sut.fetch();

    verify(() => (fetchSecureCacheStorageSpy.fetchSecure(key: 'token'))).called(1);

  });

  test('Should return AccountEntity if FetchSecure success', () async {

    fetchSecureCacheStorageSpy.mockFetchSecure(token);

    final account = await sut.fetch();

    expect(account, AccountEntity(token));
  });

  test('Should LocalLoadCurrentAccount throw UnexpectedError if FetchSecure throws', () async {

    fetchSecureCacheStorageSpy.mockFetchSecureError();

    final future = sut.fetch();

    expect(future, throwsA(DomainError.unexpected));
    
  });

  test('Should LocalLoadCurrentAccount throw UnexpectedError if fetch returns null', () async {

    fetchSecureCacheStorageSpy.mockFetchSecure(null);

    final future = sut.fetch();

    expect(future, throwsA(DomainError.unexpected));
    
  });

}
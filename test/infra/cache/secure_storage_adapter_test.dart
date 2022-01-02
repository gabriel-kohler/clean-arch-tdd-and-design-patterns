import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/infra/cache/cache.dart';

import '../mocks/mocks.dart';

void main() {

  late FlutterSecureStorageSpy flutterSecureStorageSpy;
  late SecureStorageAdapter sut;
  late AccountEntity account;
  late String key;

  setUp(() {
    flutterSecureStorageSpy = FlutterSecureStorageSpy();
    sut = SecureStorageAdapter(flutterSecureStorage: flutterSecureStorageSpy);
    account = AccountEntity(faker.guid.guid());
    key = 'token';
  });

  group('Save Secure', () {

    test('Should SecureStorageAdapter calls saveSecure with correct values', () async {
      
      flutterSecureStorageSpy.mockSaveSecure();

      await sut.saveSecure(key: 'token', value: account.token);

      verify(() => (flutterSecureStorageSpy.write(key: key, value: account.token)));
    });

    test('Should SecureStorageAdapter throw if FlutterSecureStorage throws', () async {

      flutterSecureStorageSpy.mockSaveSecureError();

      final future = sut.saveSecure(key: key, value: account.token);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });

  });

  group('Fetch Secure', () {

    test('Should SecureStorageAdapter calls FetchSecure with correct values', () async {

      flutterSecureStorageSpy.mockFetchSecure('any_token');
      
      await sut.fetchSecure(key: key);

      verify(() => (flutterSecureStorageSpy.read(key: key))).called(1);

    });

    test('Should SecureStorageAdapter return token if FetchSecure success', () async {
      
      flutterSecureStorageSpy.mockFetchSecure('any_token');

      final account = await sut.fetchSecure(key: key);

      expect(account, 'any_token');
    });

    test('Should SecureStorageAdapter throw if FetchSecure throws', () async {

      flutterSecureStorageSpy.mockFetchSecureError();

      final future = sut.fetchSecure(key: key);

      expect(future, throwsA(TypeMatcher<Exception>()));

    });

  });

  group('delete', () {

    

    test('Should call delete cache with correct key', () async {

      flutterSecureStorageSpy.mockDeleteSecure();

       await sut.deleteSecure(key: key);

      verify(() => (flutterSecureStorageSpy.delete(key: key))).called(1);
    });

    test('Should throw if delete throws', () async {

      flutterSecureStorageSpy.mockDeleteSecureError();
    
      final future = sut.deleteSecure(key: key);

      expect(future, throwsA(TypeMatcher<Exception>()));

    });

  });
  
}

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

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

    When mockSaveSecureCall() => when(() => (flutterSecureStorageSpy.write(key: any(named: 'key'), value: any(named: 'value'))));
    mockSaveSecureError() => mockSaveSecureCall().thenThrow(Exception());
    
    test('Should SecureStorageAdapter calls saveSecure with correct values', () async {
      await sut.saveSecure(key: 'token', value: account.token);

      verify(() => (flutterSecureStorageSpy.write(key: key, value: account.token)));
    });

    test('Should SecureStorageAdapter throw if FlutterSecureStorage throws', () async {

      mockSaveSecureError();

      final future = sut.saveSecure(key: key, value: account.token);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });

  });

  group('Fetch Secure', () {

    When mockFetchSecureCall() => when(() => (flutterSecureStorageSpy.read(key: any(named: 'key'))));
    mockFetchSecure() => mockFetchSecureCall().thenAnswer((_) async => 'any_token');
    mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

    test('Should SecureStorageAdapter calls FetchSecure with correct values', () async {
      
      await sut.fetchSecure(key: key);

      verify(() => (flutterSecureStorageSpy.read(key: key))).called(1);

    });

    test('Should SecureStorageAdapter return token if FetchSecure success', () async {
      
      mockFetchSecure();

      final account = await sut.fetchSecure(key: key);

      expect(account, 'any_token');
    });

    test('Should SecureStorageAdapter throw if FetchSecure throws', () async {

      mockFetchSecureError();

      final future = sut.fetchSecure(key: key);

      expect(future, throwsA(TypeMatcher<Exception>()));

    });

  });

  group('delete', () {

    When mockDeleteSecureCall() => when(() => (flutterSecureStorageSpy.delete(key: any(named: 'key'))));
    mockDeleteSecureError() => mockDeleteSecureCall().thenThrow(Exception());

    test('Should call delete cache with correct key', () async {
       await sut.deleteSecure(key: key);

      verify(() => (flutterSecureStorageSpy.delete(key: key))).called(1);
    });

    test('Should throw if delete throws', () async {

      mockDeleteSecureError();
    
      final future = sut.deleteSecure(key: key);

      expect(future, throwsA(TypeMatcher<Exception>()));

    });

  });
  
}

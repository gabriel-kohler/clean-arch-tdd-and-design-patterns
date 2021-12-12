import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {

  FlutterSecureStorageSpy flutterSecureStorageSpy;
  SecureStorageAdapter sut;
  AccountEntity account;
  String key;

  setUp(() {
    flutterSecureStorageSpy = FlutterSecureStorageSpy();
    sut = SecureStorageAdapter(flutterSecureStorage: flutterSecureStorageSpy);
    account = AccountEntity(faker.guid.guid());
    key = 'token';
  });

  group('Save Secure', () {
    test('Should SecureStorageAdapter calls saveSecure with correct values', () async {
      await sut.saveSecure(key: 'token', value: account.token);

      verify(flutterSecureStorageSpy.write(key: key, value: account.token));
    });

    test('Should SecureStorageAdapter throw if FlutterSecureStorage throws', () async {

      when(flutterSecureStorageSpy.write(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());

      final future = sut.saveSecure(key: key, value: account.token);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });

  });

  group('Fetch Secure', () {
    test('Should SecureStorageAdapter calls FetchSecure with correct values', () async {
      
      await sut.fetchSecure(key: key);

      verify(flutterSecureStorageSpy.read(key: key)).called(1);

    });

  });

  
}

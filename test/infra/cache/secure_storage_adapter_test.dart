import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/domain/helpers/domain_error.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/data/cache/save_secure_current_account.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

class SecureStorageAdapter implements SaveSecureCurrentAccount {
  final FlutterSecureStorage flutterSecureStorage;

  SecureStorageAdapter({@required this.flutterSecureStorage});

  @override
  Future<void> saveSecure({String key, String value}) async {
    flutterSecureStorage.write(key: key, value: value);
  }

}

void main() {

  FlutterSecureStorageSpy flutterSecureStorageSpy;
  SecureStorageAdapter sut;
  AccountEntity account;

  setUp(() {
    flutterSecureStorageSpy = FlutterSecureStorageSpy();
    sut = SecureStorageAdapter(flutterSecureStorage: flutterSecureStorageSpy);
    account = AccountEntity(faker.guid.guid());
  });

  test('Should SecureStorageAdapter calls saveSecure with correct values', () {
    sut.saveSecure(key: 'token', value: account.token);

    verify(flutterSecureStorageSpy.write(key: 'token', value: account.token));
  });

  test('Should SecureStorageAdapter throw if FlutterSecureStorage throws', () async {

    when(flutterSecureStorageSpy.write(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());

    final future = sut.saveSecure(key: 'token', value: account.token);

    expect(future, throwsA(TypeMatcher<Exception>()));
  });
}

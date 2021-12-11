import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
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
  void saveSecure({String key, String value}) {
    flutterSecureStorage.write(key: key, value: value);
  }

}

void main() {

  test('Should SecureStorageAdapter calls saveSecure with correct values', () {
    final flutterSecureStorageSpy = FlutterSecureStorageSpy();
    final sut = SecureStorageAdapter(flutterSecureStorage: flutterSecureStorageSpy);
    final account = AccountEntity(faker.guid.guid());

    sut.saveSecure(key: 'token', value: account.token);

    verify(flutterSecureStorageSpy.write(key: 'token', value: account.token));
  });
}

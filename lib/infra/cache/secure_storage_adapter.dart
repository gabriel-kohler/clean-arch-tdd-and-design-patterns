import 'package:meta/meta.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/data/cache/cache.dart';

class SecureStorageAdapter implements SaveSecureCurrentAccount, FetchSecureCurrentAccount {
  final FlutterSecureStorage flutterSecureStorage;

  SecureStorageAdapter({@required this.flutterSecureStorage});

  @override
  Future<void> saveSecure({@required String key, @required String value}) async {
    flutterSecureStorage.write(key: key, value: value);
  }

  Future<String> fetchSecure({@required String key}) async {
    final account = await flutterSecureStorage.read(key: key);
    return account;
  }

}
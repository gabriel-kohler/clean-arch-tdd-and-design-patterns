import 'package:meta/meta.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/data/cache/cache.dart';

class SecureStorageAdapter implements SaveSecureCurrentAccount {
  final FlutterSecureStorage flutterSecureStorage;

  SecureStorageAdapter({@required this.flutterSecureStorage});

  @override
  Future<void> saveSecure({String key, String value}) async {
    flutterSecureStorage.write(key: key, value: value);
  }

}
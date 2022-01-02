

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/data/cache/cache.dart';

class SecureStorageAdapter implements SaveSecureCurrentAccount, FetchSecureCacheStorage, DeleteSecureCacheStorage {
  final FlutterSecureStorage flutterSecureStorage;

  SecureStorageAdapter({required this.flutterSecureStorage});

  @override
  Future<void> saveSecure({required String key, required String value}) async {
    flutterSecureStorage.write(key: key, value: value);
  }

  Future<String?> fetchSecure({required String key}) async {
    final account = await flutterSecureStorage.read(key: key);
    return account;
  }

  @override
  Future<void> deleteSecure({required String key}) async {
    await flutterSecureStorage.delete(key: key);
  }


}
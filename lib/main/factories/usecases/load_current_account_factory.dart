import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/data/usecases/usecases.dart';
import '/infra/cache/cache.dart';

import '/domain/usecases/usecases.dart';

LoadCurrentAccount makeLoadCurrentAccount() {
  return LocalLoadCurrentAccount(
    fetchSecureCurrentAccount: SecureStorageAdapter(
      flutterSecureStorage: FlutterSecureStorage(),
    ),
  );
}

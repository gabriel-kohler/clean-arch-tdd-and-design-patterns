import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/domain/usecases/usecases.dart';
import '/infra/cache/cache.dart';
import '/data/usecases/usecases.dart';

AddCurrentAccount makeLocalSaveCurrentAccount() {
  return SaveCurrentAccount(
    saveSecureCurrentAccount: SecureStorageAdapter(
      flutterSecureStorage: FlutterSecureStorage(),
    ),
  );
}

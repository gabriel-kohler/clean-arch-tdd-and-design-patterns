import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/infra/cache/cache.dart';
import '/data/usecases/usecases.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() {
  return SaveCurrentAccount(
    saveSecureCurrentAccount: SecureStorageAdapter(
      flutterSecureStorage: FlutterSecureStorage(),
    ),
  );
}

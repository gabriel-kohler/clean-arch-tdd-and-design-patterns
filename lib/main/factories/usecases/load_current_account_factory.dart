import '/main/factories/cache/cache.dart';

import '/data/usecases/usecases.dart';

import '/domain/usecases/usecases.dart';

LoadCurrentAccount makeLoadCurrentAccount() {
  return LocalLoadCurrentAccount(
    fetchSecureCacheStorage: makeSecureStorageAdapter(),
  );
}

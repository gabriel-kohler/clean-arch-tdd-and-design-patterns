

import '/domain/usecases/usecases.dart';
import '/domain/entities/entities.dart';
import '/domain/helpers/helpers.dart';

import '/data/cache/cache.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  Future<AccountEntity> fetch() async {
    try {
      final account = await fetchSecureCacheStorage.fetchSecure(key: 'token');
      if (account == null) {
        throw Error();
      }
      return AccountEntity(account);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
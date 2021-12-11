import 'package:meta/meta.dart';

import '/domain/usecases/usecases.dart';
import '/domain/entities/entities.dart';
import '/domain/helpers/helpers.dart';

import '/data/cache/cache.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCurrentAccount fetchSecureCurrentAccount;

  LocalLoadCurrentAccount({@required this.fetchSecureCurrentAccount});

  Future<AccountEntity> fetch() async {
    try {
      final account = await fetchSecureCurrentAccount.fetchSecure(key: 'token');
      return AccountEntity(account);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
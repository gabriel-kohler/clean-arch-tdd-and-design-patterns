

import '/data/cache/cache.dart';

import '/domain/entities/entities.dart';
import '/domain/helpers/helpers.dart';
import '/domain/usecases/usecases.dart';


class SaveCurrentAccount implements AddCurrentAccount {

  final SaveSecureCacheStorage saveSecureCurrentAccount;

  SaveCurrentAccount({required this.saveSecureCurrentAccount});

  @override
  Future<void> save({required AccountEntity account}) async {
    try {
      saveSecureCurrentAccount.saveSecure(key: 'token', value: account.token);      
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

}
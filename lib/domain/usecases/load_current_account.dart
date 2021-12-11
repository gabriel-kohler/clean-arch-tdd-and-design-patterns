import '/domain/entities/account_entity.dart';

abstract class LoadCurrentAccount {
  Future<AccountEntity> fetch();
}
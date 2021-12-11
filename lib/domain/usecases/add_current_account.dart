import 'package:practice/domain/entities/account_entity.dart';

import 'package:meta/meta.dart';

abstract class AddCurrentAccount {
  Future<void> save({@required AccountEntity account});
}
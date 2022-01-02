import 'package:practice/domain/entities/account_entity.dart';



abstract class AddCurrentAccount {
  Future<void> save({required AccountEntity account});
}
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '/domain/entities/account_entity.dart';

abstract class AddAccount {
  Future<AccountEntity> add({@required AddAccountParams params});
}

class AddAccountParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassowrd;

  AddAccountParams({@required this.name, @required this.email, @required this.password, @required this.confirmPassowrd});

  @override
  List<Object> get props => [name, email, password, confirmPassowrd];

}
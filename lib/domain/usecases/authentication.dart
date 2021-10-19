import 'package:meta/meta.dart';

import 'package:equatable/equatable.dart';

import '/domain/entities/account_entity.dart';



abstract class Authentication {
  Future<AccountEntity> auth({
    @required AuthenticationParams params,
  });
}

class AuthenticationParams extends Equatable {
  final String email;
  final String password;

  AuthenticationParams({
    @required this.email,
    @required this.password,
  });

  @override
  List get props => [email, password];
}

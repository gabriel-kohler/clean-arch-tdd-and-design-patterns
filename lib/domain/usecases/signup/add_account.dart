import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AddAccount {
  Future<void> add({@required AddAccountParams params});
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
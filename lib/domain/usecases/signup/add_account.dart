import 'package:meta/meta.dart';

abstract class AddAccount {
  Future<void> add({@required AddAccountParams params});
}

class AddAccountParams {
  final String name;
  final String email;
  final String password;
  final String confirmPassowrd;

  AddAccountParams({@required this.email, @required this.password, @required this.confirmPassowrd, @required this.name});

}
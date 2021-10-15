import 'dart:async';
import 'package:meta/meta.dart';

import  '/presentation/dependencies/dependencies.dart';

class LoginState {
  String emailError;
  String passwordError;

  bool get isFormValid => false;
}

class StreamLoginPresenter {

  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get emailErrorStream => _controller.stream.map((state) => state.emailError).distinct();
  Stream<String> get passwordErrorStream => _controller.stream.map((state) => state.passwordError);
  Stream<bool> get isFormValidStream => _controller.stream.map((state) => state.isFormValid).distinct();

  StreamLoginPresenter({@required this.validation});


  validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }

  validatePassword(String password) {
    _state.passwordError = validation.validate(field: 'password', value: password);
    _controller.add(_state);
  }
}
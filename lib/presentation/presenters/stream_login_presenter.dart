import 'dart:async';
import 'package:meta/meta.dart';

import '/domain/usecases/usecases.dart';

import  '/presentation/dependencies/dependencies.dart';

class LoginState {
  String email;
  String password;
  String emailError;
  String passwordError;
  bool isLoading = false;

  bool get isFormValid => emailError == null 
    && passwordError == null 
    && email != null 
    && password != null ? true : false;
}

class StreamLoginPresenter {

  final Authentication authentication;
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get emailErrorStream => _controller.stream.map((state) => state.emailError).distinct();
  Stream<String> get passwordErrorStream => _controller.stream.map((state) => state.passwordError).distinct();
  Stream<bool> get isFormValidStream => _controller.stream.map((state) => state.isFormValid).distinct();
  Stream<bool> get isLoadingStream => _controller.stream.map((state) => state.isLoading).distinct();

  StreamLoginPresenter({@required this.validation, @required this.authentication});

  void _updateStream() => _controller.add(_state);

  validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(field: 'email', value: email);
    _updateStream();
  }

  validatePassword(String password) {
    _state.password = password;
    _state.passwordError = validation.validate(field: 'password', value: password);
    _updateStream();
  }

  Future<void> auth() async {
    _state.isLoading = true;
    _updateStream();
    await authentication.auth(
      params: AuthenticationParams(
        email: _state.email, 
        password: _state.password
      ),
    );
    _state.isLoading = false;
    _updateStream();
  }
} 
import 'dart:async';
import 'package:meta/meta.dart';

import '/utils/app_routes.dart';

import '/domain/usecases/usecases.dart';
import '/domain/helpers/domain_error.dart';

import '/presentation/dependencies/dependencies.dart';
import '/ui/pages/login/login_presenter.dart';

class LoginState {
  String email;
  String password;
  String emailError;
  String passwordError;
  String mainError;
  String navigateTo;
  bool isLoading = false;

  bool get isFormValid => emailError == null 
    && passwordError == null 
    && email != null 
    && password != null ? true : false;
}

class StreamLoginPresenter implements LoginPresenter {

  final Authentication authentication;
  final Validation validation;
  final AddCurrentAccount localSaveCurrentAccount;
  var _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get emailErrorStream => _controller?.stream?.map((state) => state.emailError)?.distinct();
  Stream<String> get passwordErrorStream => _controller?.stream?.map((state) => state.passwordError)?.distinct();
  Stream<String> get mainErrorStream => _controller?.stream?.map((state) => state.mainError)?.distinct();
  Stream<String> get navigateToStream => _controller?.stream?.map((state) => state.navigateTo)?.distinct();
  Stream<bool> get isFormValidStream => _controller?.stream?.map((state) => state.isFormValid)?.distinct();
  Stream<bool> get isLoadingStream => _controller?.stream?.map((state) => state.isLoading)?.distinct();

  StreamLoginPresenter({@required this.validation, @required this.authentication, @required this.localSaveCurrentAccount});

  void _updateStream() => _controller?.add(_state);

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
    try {
      final account = await authentication.auth(
        params: AuthenticationParams(
          email: _state.email, 
          password: _state.password
        ),
      );
      await localSaveCurrentAccount.save(account: account);
      _state.navigateTo = AppRoute.HomePage;
      _updateStream();
    } on DomainError catch (error) {
      _state.mainError = error.description;
    }
    
    _state.isLoading = false;
    _updateStream();
  }

  void dispose() {
    _controller.close();
    _controller = null;
  }

} 
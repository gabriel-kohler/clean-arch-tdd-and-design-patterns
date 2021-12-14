import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '/utils/app_routes.dart';

import '/domain/helpers/helpers.dart';
import '/domain/usecases/usecases.dart';

import '/presentation/dependencies/dependencies.dart';
import '/ui/pages/login/login_presenter.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {

  final Authentication authentication;
  final Validation validation;
  final AddCurrentAccount localSaveCurrentAccount;

  GetxLoginPresenter({@required this.authentication, @required this.validation, @required this.localSaveCurrentAccount});

  var _emailError = RxString(null);
  var _passwordError = RxString(null);
  var _mainError = RxString(null);
  var _navigateTo = RxString(null);
  var _isLoading = false.obs;
  var _isFormValid = false.obs;

  String _email;
  String _password;

  @override
  Stream<String> get emailErrorStream => _emailError.stream;

  @override
  Stream<String> get passwordErrorStream => _passwordError.stream;

  @override
  Stream<String> get mainErrorStream => _mainError.stream;

  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

   @override
   Stream<String> get navigateToStream => _navigateTo.stream;
  
  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = validation.validate(field: 'password', value: password);
    _validateForm();
  }

  void _validateForm() {
   _isFormValid.value = _emailError.value == null 
    && _passwordError.value == null 
    && _email != null 
    && _password != null ? true : false;
}

  @override
  Future<void> auth() async {
    try {
      _isLoading.value = true;
      final account = await authentication.auth(
        params: AuthenticationParams(
          email: _email, 
          password: _password
        ),
      );
        await localSaveCurrentAccount.save(account: account);
        _navigateTo.value = AppRoute.HomePage;
    } on DomainError catch (error) {
      _mainError.value = error.description;
      _isLoading.value = false;
    }
  }

}
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '/utils/app_routes.dart';

import '/domain/helpers/helpers.dart';
import '/domain/usecases/usecases.dart';

import '/presentation/dependencies/dependencies.dart';

import '/ui/pages/login/login_presenter.dart';
import '/ui/helpers/errors/errors.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {

  final Authentication authentication;
  final Validation validation;
  final AddCurrentAccount localSaveCurrentAccount;

  GetxLoginPresenter({@required this.authentication, @required this.validation, @required this.localSaveCurrentAccount});

  var _emailError = Rx<UIError>(null);
  var _passwordError = Rx<UIError>(null);
  var _mainError = Rx<UIError>(null);
  var _navigateTo = RxString(null);
  var _isLoading = false.obs;
  var _isFormValid = false.obs;

  String _email;
  String _password;

  @override
  Stream<UIError> get emailErrorStream => _emailError.stream;

  @override
  Stream<UIError> get passwordErrorStream => _passwordError.stream;

  @override
  Stream<UIError> get mainErrorStream => _mainError.stream;

  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

   @override
   Stream<String> get navigateToStream => _navigateTo.stream;
  
  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  UIError _validateField(String field) {
    final formData = {
      'email' : _email,
      'password' : _password,
    };
    final error = validation.validate(field: field, inputFormData: formData);
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;  
      default: 
        return null;
    }
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
      _mainError.value = null;
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
      switch (error) {
        case DomainError.invalidCredentials:
           _mainError.value = UIError.invalidCredentials;
          break;
        default:
           _mainError.value = UIError.unexpected;
      }
      _isLoading.value = false;
    }
  }

  @override
  void goToSignUp() {
    _navigateTo.value = AppRoute.SignUpPage;
  }

}
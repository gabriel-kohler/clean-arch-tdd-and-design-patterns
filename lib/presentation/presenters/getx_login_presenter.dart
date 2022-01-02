import 'package:get/get.dart';


import '/utils/app_routes.dart';

import '/domain/helpers/helpers.dart';
import '/domain/usecases/usecases.dart';

import '/presentation/mixins/mixins.dart';
import '/presentation/dependencies/dependencies.dart';

import '/ui/pages/login/login_presenter.dart';
import '/ui/helpers/errors/errors.dart';

class GetxLoginPresenter extends GetxController with LoadingManager, NavigationManager, FormManager, UIMainErrorManager implements LoginPresenter {

  final Authentication authentication;
  final Validation validation;
  final AddCurrentAccount localSaveCurrentAccount;

  GetxLoginPresenter({required this.authentication, required this.validation, required this.localSaveCurrentAccount});

  var _emailError = Rx<UIError?>(null);
  var _passwordError = Rx<UIError?>(null);

  String? _email;
  String? _password;

  @override
  Stream<UIError?> get emailErrorStream => _emailError.stream;

  @override
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;

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

  UIError? _validateField(String field) {
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
   isFormValid = _emailError.value == null 
    && _passwordError.value == null 
    && _email != null 
    && _password != null ? true : false;
}

  @override
  Future<void> auth() async {
    try {
      mainError = null;
      isLoading = true;
      final account = await authentication.auth(
        params: AuthenticationParams(
          email: _email!, 
          password: _password!
        ),
      );
        await localSaveCurrentAccount.save(account: account);
        navigateTo = AppRoute.SurveysPage;
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
           mainError = UIError.invalidCredentials;
          break;
        default:
           mainError = UIError.unexpected;
      }
      isLoading = false;
    }
  }

  @override
  void goToSignUp() {
    navigateTo = AppRoute.SignUpPage;
  }

}
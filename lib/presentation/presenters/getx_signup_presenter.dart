import 'package:get/get.dart';


import '/utils/utils.dart';

import '/data/usecases/usecases.dart';

import '/domain/helpers/helpers.dart';
import '/domain/usecases/usecases.dart';

import '/presentation/mixins/mixins.dart';
import '/presentation/dependencies/dependencies.dart';

import '/ui/helpers/errors/ui_error.dart';
import '/ui/pages/pages.dart';

class GetxSignUpPresenter extends GetxController with 
LoadingManager, 
NavigationManager, 
FormManager, 
UIMainErrorManager 
implements SignUpPresenter {

  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  GetxSignUpPresenter({required this.validation, required this.addAccount, required this.saveCurrentAccount});

  String? _name;
  String? _email;
  String? _password;
  String? _confirmPassword;

  var _nameError = Rx<UIError?>(null);
  var _emailError = Rx<UIError?>(null);
  var _passwordError = Rx<UIError?>(null);
  var _confirmPasswordError = Rx<UIError?>(null);

  @override
  Stream<UIError?> get nameErrorStream => _nameError.stream;

  @override
  Stream<UIError?> get emailErrorStream => _emailError.stream;

  @override
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;

  @override
  Stream<UIError?> get confirmPasswordErrorStream => _confirmPasswordError.stream;

  void _validateForm() {
   isFormValid = _emailError.value == null 
    && _passwordError.value == null 
    && _nameError.value == null
    && _confirmPasswordError.value == null
    && _email != null 
    && _name != null
    && _confirmPassword != null
    && _password != null ? true : false;
}

  UIError? _validateField(String field) {
    final formData = {
      'name' : _name,
      'email' : _email,
      'password' : _password,
      'confirmPassword' : _confirmPassword,
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

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  @override
  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField('name');
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

   @override
  void validateConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    _confirmPasswordError.value = _validateField('confirmPassword');
    _validateForm();
  }

  @override
  Future<void> signUp() async {

    final params = AddAccountParams(
      name: _name!,
      email: _email!,
      password: _password!,
      confirmPassowrd: _confirmPassword!,
    );

    try {
      mainError = null;
      isLoading = true;
      final account = await addAccount.add(params: params);
      await saveCurrentAccount.save(account: account);
      navigateTo = AppRoute.SurveysPage;
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emainInUse:
          mainError = UIError.emailInUse;
          break;
        default:
          mainError = UIError.unexpected;
      }
      isLoading = false;
    }
  }

  @override
  void goToLogin() {
    navigateTo = AppRoute.LoginPage;
  }

}
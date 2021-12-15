import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '/presentation/dependencies/dependencies.dart';

import '/ui/helpers/errors/ui_error.dart';
import '/ui/pages/pages.dart';

class GetxSignUpPresenter extends GetxController implements SignUpPresenter {

  final Validation validation;

  GetxSignUpPresenter({@required this.validation});

  String _name;
  String _email;
  String _password;
  String _confirmPassword;

  var _nameError = Rx<UIError>(null);
  var _emailError = Rx<UIError>(null);
  var _passwordError = Rx<UIError>(null);
  var _confirmPasswordError = Rx<UIError>(null);
  var _mainError = Rx<UIError>(null);
  var _isFormValid = false.obs;
  var _isLoading = false.obs;
  var _navigateTo = Rx<String>(null);

  @override
  Stream<UIError> get nameErrorStream => _nameError.stream;
  @override
  Stream<UIError> get emailErrorStream => _emailError.stream;
  @override
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  @override
  Stream<UIError> get confirmPasswordErrorStream => _confirmPasswordError.stream;
  @override
  Stream<UIError> get mainErrorStream => _mainError.stream;
  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  @override
  Stream<String> get navigateToStream => _navigateTo.stream;
  
  void _validateForm() {
   _isFormValid.value = _emailError.value == null 
    && _passwordError.value == null 
    && _email != null 
    && _password != null ? true : false;
}

  @override
  Future<void> signUp() {
    
  }

  UIError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);
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
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

   @override
  void validateConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    _validateField(field: 'confirmPassword', value: confirmPassword);
  }

}
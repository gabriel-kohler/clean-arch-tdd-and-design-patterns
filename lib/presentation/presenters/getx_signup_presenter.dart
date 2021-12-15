import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '/presentation/dependencies/dependencies.dart';

import '/ui/helpers/errors/ui_error.dart';
import '/ui/pages/pages.dart';

class GetxSignUpPresenter extends GetxController implements SignUpPresenter {

  final Validation validation;

  GetxSignUpPresenter({@required this.validation});

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
  

  @override
  Future<void> signUp() {
    
  }

  @override
  void validateConfirmPassword(String confirmPassword) {
    
  }

  @override
  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
  }

  @override
  void validateName(String name) {
    
  }

  @override
  void validatePassword(String password) {
    
  }

}
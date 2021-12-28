import 'package:get/get.dart';

mixin FormManager on GetxController {
  var _isFormValid = false.obs;
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  set isFormValid(bool isFormValid) {
    _isFormValid.value = isFormValid;
  }
}
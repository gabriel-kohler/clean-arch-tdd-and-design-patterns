import 'package:get/get.dart';

mixin SessionManager on GetxController {
  var _isSessionExpired = false.obs;
  Stream<bool> get isSessionExpiredStream => _isSessionExpired.stream;

  set isSession(bool isSession) {
    _isSessionExpired.value = isSession;
  }
}
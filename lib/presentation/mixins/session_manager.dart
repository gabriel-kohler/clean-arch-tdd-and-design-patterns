import 'package:get/get.dart';

mixin SessionManager {
  var _isSessionExpired = RxBool();
  Stream<bool> get isSessionExpiredStream => _isSessionExpired.stream;

  set isSession(bool isSession) {
    _isSessionExpired.value = isSession;
  }
}
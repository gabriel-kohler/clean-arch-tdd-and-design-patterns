import 'package:get/get.dart';

import '/utils/utils.dart';

mixin SessionManager {
  void handleSession(Stream<bool> isSessionExpiredStream) {
    isSessionExpiredStream.listen((isExpired) {
      if (isExpired) {
        Get.offAllNamed(AppRoute.LoginPage);
      }
    });
  }
}

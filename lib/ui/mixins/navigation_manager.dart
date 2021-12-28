import 'package:get/get.dart';

mixin NavigationManager {

  void handleNavigation(Stream<String> navigateToStream, {bool clearNavigation = false}) {
    navigateToStream.listen((page) {
      if (page?.isNotEmpty == true) {
        if (clearNavigation == true) {
          Get.offAllNamed(page);
        } else {
          Get.toNamed(page);
        }
      }
    });
  }

}

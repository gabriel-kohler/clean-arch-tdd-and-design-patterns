import 'package:get/get.dart';

mixin NavigationManager on GetxController {
  var _navigateTo = RxString();
  Stream<String> get navigateToStream => _navigateTo.stream;

  set navigateTo(String navigateTo) {
    _navigateTo.value = navigateTo;
  }
}
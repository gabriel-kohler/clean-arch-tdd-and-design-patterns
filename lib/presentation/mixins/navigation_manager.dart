import 'package:get/get.dart';

mixin NavigationManager {
  var _navigateTo = RxString();
  Stream<String> get navigateToStream => _navigateTo.stream;

  set navigateTo(String navigateTo) {
    _navigateTo.value = navigateTo;
  }
}
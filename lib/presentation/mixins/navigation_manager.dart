import 'package:get/get.dart';

mixin NavigationManager on GetxController {
  var _navigateTo = Rx<String?>(null);
  Stream<String?> get navigateToStream => _navigateTo.stream;

  set navigateTo(String navigateTo) {
    _navigateTo.subject.add(navigateTo);
  }
}
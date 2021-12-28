import 'package:get/get.dart';

import '/ui/helpers/errors/errors.dart';

mixin UIMainErrorManager on GetxController {
  var _mainError = Rx<UIError>();
  Stream<UIError> get mainErrorStream => _mainError.stream;

  set mainError(UIError mainError) {
    _mainError.value = mainError;
  }
}
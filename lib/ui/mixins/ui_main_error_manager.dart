import 'package:flutter/cupertino.dart';

import '/ui/components/components.dart';
import '/ui/helpers/helpers.dart';

mixin UIMainErrorManager {
  void handleMainError(Stream<UIError?> mainErrorStream, BuildContext context) {
    mainErrorStream.listen((UIError? mainError) {
      if (mainError != null) {
        showErrorMessage(context, mainError.description);
      }
    });
  }
}

import 'package:flutter/cupertino.dart';

import '/ui/components/components.dart';

mixin LoadingManager {
  void handleLoading(Stream<bool> isLoadingStream, BuildContext context) {
    isLoadingStream.listen(
      (isLoading) {
        if (isLoading == true) {
          showLoading(context);
        } else {
          hideLoading(context);
        }
      },
    );
  }
}

import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '/utils/app_routes.dart';

import '/ui/pages/pages.dart';
import '/domain/usecases/usecases.dart';

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});

  var _navigateTo = RxString(null);
  
  @override
  Stream<String> get navigateToStream => _navigateTo.stream;

  Future<void> checkAccount() async {

    try {
      final account = await loadCurrentAccount.fetch();

      if (account.token != null) {
        _navigateTo.value = AppRoute.SurveysPage;
      } else {
        _navigateTo.value = AppRoute.LoginPage;
      }

    } catch (error) {
        _navigateTo.value = AppRoute.LoginPage;
    }

  }

}
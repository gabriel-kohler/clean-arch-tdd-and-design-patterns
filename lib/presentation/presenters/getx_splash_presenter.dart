import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '/utils/app_routes.dart';

import '/domain/usecases/usecases.dart';

import '/presentation/mixins/mixins.dart';

import '/ui/pages/pages.dart';

class GetxSplashPresenter extends GetxController with NavigationManager implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});

  Future<void> checkAccount() async {

    try {
      final account = await loadCurrentAccount.fetch();
      if (account.token != null) {
       navigateTo = AppRoute.SurveysPage;
      } else {
       navigateTo = AppRoute.LoginPage;
      }

    } catch (error) {
       navigateTo = AppRoute.LoginPage;
    }

  }

}
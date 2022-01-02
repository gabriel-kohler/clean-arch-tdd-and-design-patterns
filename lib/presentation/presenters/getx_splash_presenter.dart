import 'package:get/get.dart';


import '/utils/app_routes.dart';

import '/domain/usecases/usecases.dart';

import '/presentation/mixins/mixins.dart';

import '/ui/pages/pages.dart';

class GetxSplashPresenter extends GetxController with NavigationManager implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({required this.loadCurrentAccount});

  Future<void> checkAccount() async {

    try {
      await loadCurrentAccount.fetch();
      navigateTo = AppRoute.SurveysPage;
    } catch (error) {
       navigateTo = AppRoute.LoginPage;
    }

  }

}
import '../../factories.dart';
import '/presentation/presenters/presenters.dart';
import '/ui/pages/splash/splash.dart';

SplashPresenter makeSplashPresenter() {
  return GetxSplashPresenter(loadCurrentAccount: makeLoadCurrentAccount());
}
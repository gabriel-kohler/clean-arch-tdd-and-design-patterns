import '/presentation/presenters/presenters.dart';
import '/ui/pages/login/login_presenter.dart';

import '../../factories.dart';
import 'login.dart';

LoginPresenter makeStreamLoginPresenter() {
  return StreamLoginPresenter(
    validation: makeValidationComposite(),
    authentication: makeRemoteAuthentication(),
    localSaveCurrentAccount: makeLocalSaveCurrentAccount(),
  );
}

LoginPresenter makeGetxLoginPresenter() {
  return GetxLoginPresenter(
    validation: makeValidationComposite(),
    authentication: makeRemoteAuthentication(),
    localSaveCurrentAccount: makeLocalSaveCurrentAccount(),
  );
}

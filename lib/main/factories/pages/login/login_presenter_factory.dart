import '/presentation/presenters/presenters.dart';
import '/ui/pages/login/login_presenter.dart';

import '../../factories.dart';

LoginPresenter makeGetxLoginPresenter() {
  return GetxLoginPresenter(
    validation: makeValidationComposite(validations: makeLoginValidations()),
    authentication: makeRemoteAuthentication(),
    localSaveCurrentAccount: makeLocalSaveCurrentAccount(),
  );
}

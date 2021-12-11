import '/presentation/presenters/presenters.dart';
import '/ui/pages/login/login_presenter.dart';

import '../../factories.dart';
import 'login.dart';

LoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(
    validation: makeValidationComposite(),
    authentication: makeRemoteAuthentication(),
  );
}

import '/ui/pages/pages.dart';
import '/main/factories/factories.dart';
import '/presentation/presenters/presenters.dart';

SignUpPresenter makeSignUpPresenter() {
  return GetxSignUpPresenter(
    addAccount: makeRemoteAddAccount(),
    saveCurrentAccount: makeLocalSaveCurrentAccount(),
    validation: makeValidationComposite(validations: makeSignUpValidations()),

  );
}
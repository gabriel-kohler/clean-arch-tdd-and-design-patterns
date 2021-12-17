import 'package:practice/utils/i18n/i18n.dart';

enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
  emailInUse,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials:
        return R.strings.msgInvalidCredentials;
      case UIError.invalidField:
        return R.strings.msgInvalidField;
      case UIError.requiredField:
        return R.strings.msgRequiredField;
      case UIError.emailInUse:
        return R.strings.msgEmailInUse;
      default:
        return R.strings.msgUnexpectedError;
    }
  }
}

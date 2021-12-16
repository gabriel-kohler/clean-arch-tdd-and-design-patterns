import 'package:practice/validation/dependencies/dependencies.dart';

import '/validation/validators/validation_composite.dart';
import '/validation/validators/validators.dart';

ValidationComposite makeValidationComposite() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password'),
  ];
}

import '/main/builders/builders.dart';

import '/validation/dependencies/dependencies.dart';
import '/validation/validators/validation_composite.dart';
import '/validation/validators/validators.dart';

ValidationComposite makeValidationComposite() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    ... ValidationBuilder.field('email').required().email().build(),
    ... ValidationBuilder.field('password').required().build(),
  ];
}



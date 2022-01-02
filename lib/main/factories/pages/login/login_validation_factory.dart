

import '/main/builders/builders.dart';
import '/main/composites/composites.dart';

import '/validation/dependencies/dependencies.dart';

ValidationComposite makeValidationComposite({required List<FieldValidation> validations}) {
  return ValidationComposite(validations);
}

List<FieldValidation> makeLoginValidations() {
  return [
    ... ValidationBuilder.field('email').required().email().build(),
    ... ValidationBuilder.field('password').minLength(5).required().build(),
  ];
}

List<FieldValidation> makeSignUpValidations() {
  return [
    ... ValidationBuilder.field('name').required().minLength(3).build(),
    ... ValidationBuilder.field('email').required().email().build(),
    ... ValidationBuilder.field('password').required().minLength(5).build(),
    ... ValidationBuilder.field('confirmPassword').required().sameAs('password').build(),
  ];
}
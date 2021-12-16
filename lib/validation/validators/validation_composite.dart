import 'package:meta/meta.dart';

import '/presentation/dependencies/dependencies.dart';

import '/validation/dependencies/dependencies.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  ValidationError validate({@required String field, @required Map inputFormData}) {
    ValidationError error;
    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(inputFormData: inputFormData);
      if (error != null) {
        return error;
      }
    }
    return error;
  }
}
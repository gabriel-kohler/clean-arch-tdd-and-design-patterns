import 'package:meta/meta.dart';

import 'package:practice/validation/dependencies/dependencies.dart';
import 'package:practice/presentation/dependencies/validation.dart';

class CompareFieldValidation implements FieldValidation {
  final String field;
  final String fieldToCompare;

  CompareFieldValidation({@required this.field, @required this.fieldToCompare});

  bool invalidInputField(Map inputFormData) {
    return (inputFormData[field] != null &&
        inputFormData[fieldToCompare] != null &&
        inputFormData[field] != inputFormData[fieldToCompare]);
  }

  @override
  ValidationError validate({@required Map inputFormData}) {
    final inputInvalid = invalidInputField(inputFormData);
    if (inputInvalid) {
      return ValidationError.invalidField;
    } else {
      return null;
    }
  }
}

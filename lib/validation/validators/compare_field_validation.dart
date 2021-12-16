import 'package:meta/meta.dart';

import 'package:practice/validation/dependencies/dependencies.dart';
import 'package:practice/presentation/dependencies/validation.dart';

class CompareFieldValidation implements FieldValidation {

  final String field;
  final String fieldToCompare;

  CompareFieldValidation({@required this.field, @required this.fieldToCompare});

  @override
  ValidationError validate({@required Map inputFormData}) {
    if (inputFormData[field] == inputFormData[fieldToCompare]) {
      return null;
    } else {
      return ValidationError.invalidField;
    }
  }

}
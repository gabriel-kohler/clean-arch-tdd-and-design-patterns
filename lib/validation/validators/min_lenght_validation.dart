import 'package:meta/meta.dart';

import 'package:practice/validation/dependencies/dependencies.dart';
import 'package:practice/presentation/dependencies/validation.dart';

class MinLengthValidation implements FieldValidation {

  final String field;
  final int minLengthCaracters;

  bool isValid = false;

  MinLengthValidation({@required this.field, @required this.minLengthCaracters});

  bool validLengthCaracter(String value) {
    if (value != null) {
      return value.length == 5;
    } else {
      return false;
    }
  }

  @override
  ValidationError validate({@required String value}) {
    isValid = validLengthCaracter(value);
    if (value?.isNotEmpty == true && isValid) {
      return null;
    } else {
      return ValidationError.invalidField;
    }
  }

}
import 'package:meta/meta.dart';

import 'package:practice/validation/dependencies/dependencies.dart';
import 'package:practice/presentation/dependencies/validation.dart';

class MinLengthValidation implements FieldValidation {

  final String field;
  final int minLengthValidation;

  MinLengthValidation({@required this.field, @required this.minLengthValidation});

  @override
  ValidationError validate({@required String value}) {
    if (value.isEmpty){
      return ValidationError.invalidField;
    } else {
      return null;
    }
  }

}
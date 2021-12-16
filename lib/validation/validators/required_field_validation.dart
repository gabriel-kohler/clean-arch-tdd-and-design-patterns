import 'package:meta/meta.dart';

import '/presentation/dependencies/dependencies.dart';

import '/validation/dependencies/dependencies.dart';

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  ValidationError validate({@required String value}) {
    return value?.isNotEmpty == true ? null : ValidationError.requiredField;
  }
}
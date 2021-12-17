import 'package:meta/meta.dart';

abstract class Validation {
  ValidationError validate({@required String field, @required Map inputFormData});
}

enum ValidationError {
  requiredField,
  invalidField,
}
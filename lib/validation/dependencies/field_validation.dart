import 'package:meta/meta.dart';

import '/presentation/dependencies/dependencies.dart';

abstract class FieldValidation {
  String get field;
  ValidationError validate({@required String value});
}
import '/presentation/dependencies/dependencies.dart';

abstract class FieldValidation {
  String get field;
  ValidationError validate(String value);
}
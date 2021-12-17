import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '/presentation/dependencies/dependencies.dart';

import '/validation/dependencies/dependencies.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  ValidationError validate({@required Map inputFormData}) {
    return inputFormData[field]?.isNotEmpty == true ? null : ValidationError.requiredField;
  }

  @override
  List<Object> get props => [field];
}
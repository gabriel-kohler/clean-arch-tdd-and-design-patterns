import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:practice/validation/dependencies/dependencies.dart';
import 'package:practice/presentation/dependencies/validation.dart';

class MinLengthValidation extends Equatable implements FieldValidation {

  final String field;
  final int minLengthCaracters;

  MinLengthValidation({@required this.field, @required this.minLengthCaracters});


  @override
  ValidationError validate({@required Map inputFormData}) {
    final String value = inputFormData[field];
    return value != null && value.length >= minLengthCaracters ? null : ValidationError.invalidField;
  }

  @override
  List<Object> get props => [field, minLengthCaracters];

}
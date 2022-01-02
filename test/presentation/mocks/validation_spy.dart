import 'package:mocktail/mocktail.dart';

import 'package:practice/presentation/dependencies/dependencies.dart';

class ValidationSpy extends Mock implements Validation {
  When mockValidationCall(String? field) => when(() => this.validate(
      field: field == null ? any(named: 'field') : field,
      inputFormData: any(named: 'inputFormData')));

  void mockValidation({String? field}) => this.mockValidationCall(field).thenReturn(null);
  
  void mockValidationError({String? field, ValidationError? value}) => this.mockValidationCall(field).thenReturn(value);
  
}
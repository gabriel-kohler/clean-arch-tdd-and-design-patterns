import 'package:mocktail/mocktail.dart';

import 'package:practice/presentation/dependencies/dependencies.dart';
import 'package:practice/validation/dependencies/dependencies.dart';

class FieldValidationSpy extends Mock implements FieldValidation {

  FieldValidationSpy() {
    this.mockValidation();
    this.mockFieldName('any_field');
  }

  When mockValidationCall() =>  when(() => this.validate(inputFormData: any(named: 'inputFormData')));
  void mockValidation() => this.mockValidationCall().thenReturn(null);
  void mockValidationError(ValidationError error) => this.mockValidationCall().thenReturn(error);

  void mockFieldName(String fieldName) => when(() => (this.field)).thenReturn(fieldName);

}
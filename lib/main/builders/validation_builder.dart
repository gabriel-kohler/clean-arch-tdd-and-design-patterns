import 'package:practice/validation/dependencies/dependencies.dart';
import 'package:practice/validation/validators/validators.dart';

class ValidationBuilder {

static ValidationBuilder? _instance;

String fieldName;
List<FieldValidation> validations = [];

ValidationBuilder._(this.fieldName);


static ValidationBuilder field(String fieldName) {
  _instance = ValidationBuilder._(fieldName);
  return _instance!;
}

 ValidationBuilder required() {
   validations.add(RequiredFieldValidation(fieldName));
   return this;
 }

 ValidationBuilder email() {
   validations.add(EmailValidation(fieldName));
   return this;
 }

 ValidationBuilder minLength(int minLengthCaracters) {
   validations.add(MinLengthValidation(field: fieldName, minLengthCaracters: minLengthCaracters));
   return this;
 }

 ValidationBuilder sameAs(String fieldToCompare) {
   validations.add(CompareFieldValidation(field: fieldName, fieldToCompare: fieldToCompare));
   return this;
 }

  List<FieldValidation> build() => validations;

}
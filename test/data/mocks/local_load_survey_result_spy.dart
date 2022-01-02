import 'package:mocktail/mocktail.dart';

import 'package:practice/data/usecases/usecases.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/helpers/helpers.dart';

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {

  LocalLoadSurveyResultSpy() {
    this.mockValidate();
    this.mockSave();
  }

  When mockLocalSurveyResultCall() => when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLocalSurveyResult(SurveyResultEntity surveyResult) => this.mockLocalSurveyResultCall().thenAnswer((_) async => surveyResult);
  void mockLocalSurveyResultError(DomainError error) => this.mockLocalSurveyResultCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => this.validate(surveyId: any(named: 'surveyId')));
  void mockValidate() => this.mockValidateCall().thenAnswer((_) async => _);
  void mockValidateError() => this.mockValidateCall().thenThrow(Exception());

  When mockSaveCall() => when(() => this.save(surveyResult: any(named: 'surveyResult')));
  void mockSave() => this.mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => this.mockSaveCall().thenThrow(Exception());
   
}
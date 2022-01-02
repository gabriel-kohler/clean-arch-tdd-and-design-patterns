import 'package:mocktail/mocktail.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/domain/usecases/usecases.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {

  When mockLoadSurveyResultCall() => when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoadSurveyResult(SurveyResultEntity data) => this.mockLoadSurveyResultCall().thenAnswer((_) async => data);
  void mockLoadSurveyResultError(DomainError error) => this.mockLoadSurveyResultCall().thenThrow(error);

}
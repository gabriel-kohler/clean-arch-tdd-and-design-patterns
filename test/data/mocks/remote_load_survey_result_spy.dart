import 'package:mocktail/mocktail.dart';

import 'package:practice/data/usecases/usecases.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/helpers/helpers.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {

  When mockRemoteSurveyResultCall() => when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockRemoteSurveyResult(SurveyResultEntity surveyResult) => this.mockRemoteSurveyResultCall().thenAnswer((_) async => surveyResult);
  void mockRemoteSurveyResultError(DomainError error) => this.mockRemoteSurveyResultCall().thenThrow(error);
}
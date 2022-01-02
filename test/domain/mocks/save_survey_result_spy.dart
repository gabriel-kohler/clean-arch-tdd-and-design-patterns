import 'package:mocktail/mocktail.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/domain/usecases/usecases.dart';

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {

  When mockSaveSurveyResultCall() => when(() => this.save(answer: any(named: 'answer')));
  void mockSaveSurveyResult(SurveyResultEntity data) => this.mockSaveSurveyResultCall().thenAnswer((_) async => data);
  void mockSaveSurveyResultError(DomainError error) => this.mockSaveSurveyResultCall().thenThrow(error);

}
import '/domain/entities/entities.dart';

abstract class LoadSurveyResult {
  Future<SurveyResultEntity> loadBySurvey({String surveyId});
}
import 'package:meta/meta.dart';

import '/domain/entities/entities.dart';

abstract class SaveSurveyResult {
  Future<SurveyResultEntity> loadBySurvey({@required String surveyId});
}
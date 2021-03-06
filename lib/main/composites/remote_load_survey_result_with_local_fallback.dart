import '/domain/helpers/helpers.dart';
import '/domain/entities/entities.dart';
import '/domain/usecases/usecases.dart';

import '/data/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult {

  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({required this.remote, required this.local});

  Future<SurveyResultEntity> loadBySurvey({required String surveyId}) async {

    try {
      final result = await remote.loadBySurvey(surveyId: surveyId);
      await local.save(surveyResult: result);
      return result;
    } catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }
        await local.validate(surveyId: surveyId);
        return await local.loadBySurvey(surveyId: surveyId);
    }

    
  }

}
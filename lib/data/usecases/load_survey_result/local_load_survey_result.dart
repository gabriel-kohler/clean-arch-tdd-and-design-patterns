import 'package:meta/meta.dart';
import 'package:practice/data/models/local_survey_result_model.dart';

import '/domain/usecases/usecases.dart';

import '/domain/helpers/helpers.dart';
import '/domain/entities/entities.dart';

import '/data/cache/cache.dart';

class LocalLoadSurveyResult implements LoadSurveyResult {
  final CacheStorage cacheStorage;

  LocalLoadSurveyResult({@required this.cacheStorage});

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {

    try {
      final json = await cacheStorage.fetch(key: 'survey_result/$surveyId');
      if (json?.isEmpty != false) {
        throw Exception();
      }
      return LocalSurveyResultModel.fromJson(json).toSurveyResultEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }

  }

  Future<void> validate({@required String surveyId}) async {
    try {
      final json = await cacheStorage.fetch(key: 'survey_result/$surveyId');
      LocalSurveyResultModel.fromJson(json).toSurveyResultEntity();
    } catch (error) {
      await cacheStorage.delete(key: 'survey_result/$surveyId');
    }
  }

  Future<void> save({@required String surveyId, @required SurveyResultEntity surveyResult}) async {
    try {
      final json = LocalSurveyResultModel.fromSurveyResultEntity(surveyResult).toJson();
      await cacheStorage.save(key: 'survey_result/$surveyId', value: json);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

}
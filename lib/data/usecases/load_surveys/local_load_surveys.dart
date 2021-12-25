import 'package:meta/meta.dart';

import '/domain/usecases/usecases.dart';

import '/domain/helpers/helpers.dart';
import '/domain/entities/entities.dart';

import '/data/models/models.dart';
import '/data/cache/cache.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({@required this.cacheStorage});

  Future<List<SurveyEntity>> load() async {

    try {
      final List<dynamic> surveys = await cacheStorage.fetch(key: 'surveys');
      if (surveys?.isEmpty != false) {
        throw Exception();
      }
      return _mapToEntity(surveys);
    } catch (error) {
      throw DomainError.unexpected;
    }

  }

  Future<void> validate() async {
    try {
      final surveys = await cacheStorage.fetch(key: 'surveys');
      _mapToEntity(surveys);
    } catch (error) {
      await cacheStorage.delete(key: 'surveys');
    }
  }

  Future<void> save(List<SurveyEntity> surveys) async {
    try {
      await cacheStorage.save(key: 'surveys', value: _mapToJson(surveys));
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  List<SurveyEntity> _mapToEntity(List<Map> list) => list.map<SurveyEntity>((survey)
    => LocalSurveyModel.fromJson(survey).toSurveyEntity()).toList();

  List<Map> _mapToJson(List<SurveyEntity> list) => list.map((entity)
    => LocalSurveyModel.fromEntity(entity).toJson()).toList();

  

}
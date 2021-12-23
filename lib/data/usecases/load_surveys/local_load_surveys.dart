import 'package:meta/meta.dart';

import '/domain/usecases/usecases.dart';

import '/domain/helpers/helpers.dart';
import '/domain/entities/entities.dart';

import '/data/models/models.dart';
import '/data/cache/cache.dart';

class LocalLoadSurveys implements LoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({@required this.fetchCacheStorage});

  Future<List<SurveyEntity>> load() async {

    try {
      final List<dynamic> surveys = await fetchCacheStorage.fetch(key: 'surveys');
      if (surveys?.isEmpty != false) {
        throw Exception();
      }
      return surveys.map<SurveyEntity>((survey) => LocalSurveyModel.fromJson(survey).toSurveyEntity()).toList();
    } catch (error) {
      throw DomainError.unexpected;
    }

  }
}
import '/domain/entities/entities.dart';

abstract class LoadSurveys {
  Future<List<SurveyEntity>> load();
}
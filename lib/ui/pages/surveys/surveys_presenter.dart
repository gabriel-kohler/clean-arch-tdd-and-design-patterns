import '/ui/pages/pages.dart';

abstract class SurveysPresenter {

  Stream<List<SurveyViewModel>> get surveysStream;

  Future<void> loadData();
}
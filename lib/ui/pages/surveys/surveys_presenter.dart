import '/ui/pages/pages.dart';

abstract class SurveysPresenter {

  Stream<List<SurveyViewModel>> get surveysStream;
  Stream<String> get navigateToStream;

  Future<void> loadData();

  void goToSurveyResult(String surveyId);
}
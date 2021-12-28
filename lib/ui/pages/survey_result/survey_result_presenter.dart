import 'survey_result_viewmodel.dart';

abstract class SurveyResultPresenter {

  Stream<SurveyResultViewModel> get surveyResultStream;

  Future<void> loadData();
  
}
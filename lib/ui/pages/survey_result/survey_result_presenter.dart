import '/ui/pages/pages.dart';

abstract class SurveyResultPresenter {

  Stream<bool> get isLoadingStream;
  Stream<dynamic> get surveyResultStream;

  Future<void> loadData();
  
}
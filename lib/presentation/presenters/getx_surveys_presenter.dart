import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';
import 'package:practice/domain/helpers/domain_error.dart';
import 'package:practice/ui/helpers/errors/errors.dart';
import 'package:practice/utils/utils.dart';

import '/domain/usecases/usecases.dart';

import '/ui/pages/pages.dart';

class GetxSurveysPresenter extends GetxController implements SurveysPresenter {

  final LoadSurveys loadSurveys;

  GetxSurveysPresenter({@required this.loadSurveys});

  var _surveys = Rx<List<SurveyViewModel>>([]);
  var _navigateTo = Rx<String>();

  @override
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;

  @override
  Future<void> loadData() async {

    try {

      final surveys = await loadSurveys.load();
    
    _surveys.value = surveys.map((survey) => SurveyViewModel(
      id: survey.id, 
      question: survey.question, 
      date: DateFormat('dd MMM yyyy').format(survey.date), 
      didAnswer: survey.didAnswer,
    )).toList();
    } on DomainError {
      _surveys.subject.addError(UIError.unexpected.description, StackTrace.empty);
    }
    
  }

  @override
  void goToSurveyResult(String surveyId) {
    _navigateTo.value = '${AppRoute.SurveyResultPage}/$surveyId';
  }
}
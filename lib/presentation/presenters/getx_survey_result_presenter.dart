import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '/domain/helpers/domain_error.dart';
import '/ui/helpers/errors/errors.dart';

import '/domain/usecases/usecases.dart';

import '/ui/pages/pages.dart';

class GetxSurveyResultPresenter extends GetxController implements SurveyResultPresenter {

  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  GetxSurveyResultPresenter({@required this.loadSurveyResult, @required this.surveyId});

  var _isLoading = true.obs;
  var _surveyResult = Rx<SurveyResultViewModel>();

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  @override
  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  @override
  Future<void> loadData() async {

    try {
      _isLoading.value = true;
      final surveyResult = await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      _surveyResult.value = SurveyResultViewModel(
        surveyId: surveyResult.surveyId, 
        question: surveyResult.question, 
        answers: surveyResult.answers.map((answer) => 
        SurveyAnswerViewModel(
          image: answer.image,
          answer: answer.answer, 
          isCurrentAnswer: answer.isCurrentAnswer, 
          percent: '${answer.percent}%',
        )).toList()
      );

    } on DomainError {
      _surveyResult.subject.addError(UIError.unexpected.description, StackTrace.empty);
    }
    _isLoading.value = false;
  }
}
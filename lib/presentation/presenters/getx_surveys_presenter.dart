import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';
import 'package:practice/domain/helpers/domain_error.dart';
import 'package:practice/ui/helpers/errors/errors.dart';

import '/domain/usecases/usecases.dart';

import '/ui/pages/pages.dart';

class GetxSurveysPresenter extends GetxController implements SurveysPresenter {

  final LoadSurveys loadSurveys;

  GetxSurveysPresenter({@required this.loadSurveys});

  var _isLoading = true.obs;
  var _surveys = RxList<SurveyViewModel>([]);

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  @override
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  @override
  Future<void> loadData() async {

    try {

      _isLoading.value = true;
      final surveys = await loadSurveys.load();

    _surveys.value = surveys.map((survey) => SurveyViewModel(
      id: survey.id, 
      question: survey.question, 
      date: DateFormat('dd MMM yyyy').format(survey.date), 
      didAnswer: survey.didAnswer,
    )).toList();

    } on DomainError {
      _surveys.subject.addError(UIError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
    
  }
}
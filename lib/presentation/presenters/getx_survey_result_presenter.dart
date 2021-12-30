import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '/domain/entities/entities.dart';
import '/domain/usecases/usecases.dart';
import '/domain/helpers/helpers.dart';

import '/presentation/helpers/helpers.dart';
import '/presentation/mixins/mixins.dart';

import '/ui/helpers/errors/errors.dart';
import '/ui/pages/pages.dart';

class GetxSurveyResultPresenter extends GetxController with SessionManager implements SurveyResultPresenter {

  final LoadSurveyResult loadSurveyResult;
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;

  GetxSurveyResultPresenter({@required this.loadSurveyResult, @required this.saveSurveyResult, @required this.surveyId});

  var _surveyResult = Rx<SurveyResultViewModel>();

  @override
  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  @override
  Future<void> loadData() async {
    showResultOnAction(() => loadSurveyResult.loadBySurvey(surveyId: surveyId));
  }

  @override
  Future<void> save({String answer}) async {
    showResultOnAction(() => saveSurveyResult.save(answer: answer));
  }

  Future<void> showResultOnAction(Future<SurveyResultEntity> action()) async {
    try {
      final actionResult = await action();
      _surveyResult.subject.add(actionResult.toViewModel());
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSession = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description, StackTrace.empty);
      }
    }
  }

}
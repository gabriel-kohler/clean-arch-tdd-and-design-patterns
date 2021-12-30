import 'package:get/get.dart';

import '/presentation/presenters/presenters.dart';

import '/ui/pages/pages.dart';

import '/main/factories/factories.dart';

SurveyResultPresenter  makeGetxSurveyResultPresenter() {
  final surveyId = Get.parameters['survey_id'];
  return GetxSurveyResultPresenter(
    loadSurveyResult: makeRemoteLoadSurveyResultWithLocalFallback(surveyId),
    saveSurveyResult: makeRemoteSaveSurveyResult(surveyId),
    surveyId: surveyId,
  );
}
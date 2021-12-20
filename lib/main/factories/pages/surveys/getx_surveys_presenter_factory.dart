import '/presentation/presenters/presenters.dart';

import '/ui/pages/pages.dart';

import '/main/factories/factories.dart';

SurveysPresenter makeGetxSurveysPresenter() => GetxSurveysPresenter(loadSurveys: makeLoadSurveys());
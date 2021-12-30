import '/main/factories/factories.dart';

import '/data/usecases/usecases.dart';

import '/domain/usecases/usecases.dart';

SaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) => RemoteSaveSurveyResult(
  httpClient: makeAuthorizeHttpClientDecorator(),
  url: makeApiUrl('surveys/$surveyId/results'),
);
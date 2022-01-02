import 'package:practice/main/composites/composites.dart';
import 'package:practice/main/factories/factories.dart';

import '/data/usecases/usecases.dart';

import '/domain/usecases/usecases.dart';

RemoteLoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) => RemoteLoadSurveyResult(
  httpClient: makeAuthorizeHttpClientDecorator(),
  url: makeApiUrl('surveys/$surveyId/results'),
);

LocalLoadSurveyResult makeLocalLoadSurveyResult(String surveyId) => LocalLoadSurveyResult(
  cacheStorage: makeLocalStorageAdapter(),
);

LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(String surveyId) =>
  RemoteLoadSurveyResultWithLocalFallback(
    remote: makeRemoteLoadSurveyResult(surveyId),
    local: makeLocalLoadSurveyResult(surveyId),
  );
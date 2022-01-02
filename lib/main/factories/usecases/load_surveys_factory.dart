import '/domain/usecases/usecases.dart';

import '/data/usecases/usecases.dart';

import '/main/composites/composites.dart';
import '/main/factories/factories.dart';

RemoteLoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys'),
    );


LocalLoadSurveys makeLocalLoadSurveys() => LocalLoadSurveys(
      cacheStorage: makeLocalStorageAdapter(),
    );


LoadSurveys makeRemoteLoadSurveysWithLocalFallbacck() => RemoteLoadSurveysWithLocalFallback(
      remoteLoad: makeRemoteLoadSurveys(),
      localLoad: makeLocalLoadSurveys(),
    );

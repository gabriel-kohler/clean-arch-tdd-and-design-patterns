import '/domain/usecases/usecases.dart';

import '/data/usecases/usecases.dart';

import '/main/composites/composites.dart';
import '/main/factories/http/http.dart';
import '/main/factories/factories.dart';

LoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys'),
    );


LoadSurveys makeLocalLoadSurveys() => LocalLoadSurveys(
      cacheStorage: makeLocalStorageAdapter(),
    );


LoadSurveys makeRemoteLoadSurveysWithLocalFallbacck() => RemoteLoadSurveysWithLocalFallback(
      remoteLoad: makeRemoteLoadSurveys(),
      localLoad: makeLocalLoadSurveys(),
    );

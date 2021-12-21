import '/data/usecases/usecases.dart';

import '/domain/usecases/usecases.dart';

import '/main/factories/factories.dart';

LoadSurveys makeLoadSurveys() => RemoteLoadSurveys(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl('surveys'),
    );

import 'package:meta/meta.dart';

import '/data/usecases/usecases.dart';

import '/domain/helpers/helpers.dart';
import '/domain/entities/entities.dart';
import '/domain/usecases/usecases.dart';


class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {

  final RemoteLoadSurveys remoteLoad;
  final LocalLoadSurveys localLoad;

  RemoteLoadSurveysWithLocalFallback({@required this.remoteLoad, @required this.localLoad});

  Future<List<SurveyEntity>> load() async {

    try {
      final surveys = await remoteLoad.load();
      await localLoad.save(surveys);
      return surveys;
    } catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      } else {
        localLoad.validate();
        return localLoad.load();
      }
    }
  }

}
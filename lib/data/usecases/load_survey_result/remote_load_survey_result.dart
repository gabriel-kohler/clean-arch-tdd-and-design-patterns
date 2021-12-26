import 'package:meta/meta.dart';

import '/domain/entities/entities.dart';
import '/domain/helpers/helpers.dart';
import '/domain/usecases/usecases.dart';

import '/data/models/models.dart';
import '/data/http/http.dart';

class RemoteLoadSurveyResult implements LoadSurveyResult {

  final HttpClient httpClient;
  final String url;

  RemoteLoadSurveyResult({@required this.httpClient, @required this.url});

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {

    try {
      final json = await httpClient.request(url: url, method: 'get');
      return RemoteSurveyResultModel.fromJson(json).toSurveyEntity();
    } on HttpError catch (error) {
      (error == HttpError.forbidden) 
        ? throw DomainError.accessDenied
        : throw DomainError.unexpected; 
    }
    
    
  }

}
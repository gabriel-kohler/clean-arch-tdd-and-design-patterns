import 'package:meta/meta.dart';

import '/domain/helpers/helpers.dart';
import '/domain/entities/entities.dart';
import '/domain/usecases/usecases.dart';

import '/data/models/models.dart';
import '/data/http/http.dart';

class RemoteSaveSurveyResult implements SaveSurveyResult {
  final HttpClient httpClient;
  final String url;

  RemoteSaveSurveyResult({@required this.httpClient, @required this.url});

  Future<SurveyResultEntity> save({String answer}) async {

    try {
      final json = await httpClient.request(url: url, method: 'put', body: {'answer': answer});
      return RemoteSurveyResultModel.fromJson(json).toSurveyEntity();
    } on HttpError catch (error) {
      (error == HttpError.forbidden) 
        ? throw DomainError.accessDenied
        : throw DomainError.unexpected;
    }

  }
}

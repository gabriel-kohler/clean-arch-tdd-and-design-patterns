import 'package:meta/meta.dart';

import '/domain/entities/entities.dart';
import '/domain/helpers/helpers.dart';
import '/domain/usecases/usecases.dart';

import '/data/models/models.dart';
import '/data/http/http.dart';

class RemoteLoadSurveys implements LoadSurveys {

  final HttpClient httpClient;
  final String url;

  RemoteLoadSurveys({@required this.httpClient, @required this.url});

  Future<List<SurveyEntity>> load() async {

    try {
      final List<Map> response = await httpClient.request(url: url, method: 'get');
      return response.map((json) => RemoteSurveyModel.fromJson(json).toSurveyEntity()).toList();
    } on HttpError catch (error) {
      (error == HttpError.forbidden) 
        ? throw DomainError.accessDenied
        : throw DomainError.unexpected; 
    }
    
    
  }

}
import 'package:meta/meta.dart';

import '/data/cache/cache.dart';
import '/data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCurrentAccount fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({@required this.fetchSecureCacheStorage, @required this.decoratee});

  Future<dynamic> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
  }) async {

    try {
      final token = await fetchSecureCacheStorage.fetchSecure(key: 'token');
      final headerWithToken = headers ?? {} ..addAll({'x-access-token' : token});
      final response = await decoratee.request(url: url, method: method, body: body, headers: headerWithToken);
      return response;
    } on HttpError {
      rethrow;
    } catch (error) {
      throw HttpError.forbidden;
    }

  }


}
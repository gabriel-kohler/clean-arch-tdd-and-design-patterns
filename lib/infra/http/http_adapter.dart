import 'dart:convert';

import 'package:http/http.dart';

import '/data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<dynamic> request({
    required String url,
    required String method,
    Map? body,
    Map? headers,
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {} .. addAll({
      'content-type': 'application/json',
      'accept': 'application/json',
    }); 

    final jsonBody = _jsonBody(body);

    var response = Response('', 500);
    Future<Response>? futureResponse;

    try {

      if (method == 'post') {
        futureResponse = client.post(Uri.parse(url), headers: defaultHeaders, body: jsonBody);
      } else if (method == 'get') {
        futureResponse = client.get(Uri.parse(url), headers: defaultHeaders);
      } else if (method == 'put') {
        futureResponse = client.put(Uri.parse(url), headers: defaultHeaders, body: jsonBody);
      }

      if (futureResponse != null) {
        response = await futureResponse.timeout(Duration(seconds: 10));
      }

    } catch (error) {
      throw HttpError.serverError;
    }
    
    return _handleResponse(response);
  }

  String? _jsonBody(Map? body) {
    if (body != null) {
      return jsonEncode(body);
    } else {
      return null;
    }
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body.isNotEmpty ? jsonDecode(response.body) : null;
      case 204:
        return null;
      case 400:
        throw HttpError.badRequest;
      case 500:
        throw HttpError.serverError;
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbidden;
      default:
        throw HttpError.notFound;
    }
  }
}

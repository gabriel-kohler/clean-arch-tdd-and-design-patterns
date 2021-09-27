import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '/data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
      final headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
      };

      final jsonBody = _jsonBody(body);

      var response = Response('', 500);

      if (method == 'post')
       response = await client.post(Uri.parse(url), headers: headers, body: jsonBody);

      return _handleResponse(response);
  }

  String _jsonBody(Map body) {
    if (body != null) {
      return jsonEncode(body);
    } else {
      return null;
    }
  }



  Map _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 500) {
      throw HttpError.serverError;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else {
      throw HttpError.notFound;
    }
  }
  
}

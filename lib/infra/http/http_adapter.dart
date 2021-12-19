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

    try {

      if (method == 'post') {
        response = await client.post(Uri.parse(url), headers: headers, body: jsonBody);
      } else if (method == 'get') {
        response = await client.get(Uri.parse(url), headers: headers);
      }

    } catch (error) {
      throw HttpError.serverError;
    }

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

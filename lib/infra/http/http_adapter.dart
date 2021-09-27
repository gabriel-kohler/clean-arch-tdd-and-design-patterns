import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '/data/http/http.dart';

class HttpAdapter implements HttpClient{
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

    final jsonBody = body != null ? jsonEncode(body) : null;

    final response = await client.post(Uri.parse(url), headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } else {
      return null;
    }
  }
}
import 'dart:convert';

import 'package:practice/interface/http_service.dart';
import 'package:http/http.dart' as http;


class HttpService implements IHttpService {
  
  
  final http.Client service;

  HttpService(this.service);

  @override
  Future get(String url) async {
    final response = await service.get(Uri.parse(url));
    print(jsonDecode(response.body));
    return jsonDecode(response.body);
  }
  
}
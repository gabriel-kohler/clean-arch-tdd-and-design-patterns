import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:practice/services/dio_service.dart';
import 'package:practice/services/http_service.dart';
import 'package:practice/view/homepage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Client client = http.Client();
    final Dio dio = Dio();
    //final service = HttpService(client);
    final service = DioService(dio);
    return MaterialApp(
      home: Homepage(service),
    );
  }
}

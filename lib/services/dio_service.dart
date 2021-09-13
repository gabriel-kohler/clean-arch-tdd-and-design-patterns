import 'package:dio/dio.dart';
import 'package:practice/interface/http_service.dart';

class DioService implements IHttpService {

  final Dio service;

  DioService(this.service);


  @override
  Future get(String url) async {
    final response = await service.get(url);
    print(response.data);
    return response.data;
    
  }

  
}
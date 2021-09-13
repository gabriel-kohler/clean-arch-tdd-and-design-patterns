import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:practice/interface/http_service.dart';
import 'package:practice/provider/product_provider.dart';
import 'package:practice/services/realtime_database_fb.dart';
import 'package:practice/view/homepage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    
    final Client client = http.Client();
    RealtimeDatabase httpService = RealtimeDatabase(client);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => new ProductProvider(httpService),
        ),
      ],
      child: MaterialApp(
        home: Homepage(),
      ),
    );
  }
}

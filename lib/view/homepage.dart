import 'package:flutter/material.dart';
import 'package:practice/interface/http_service.dart';

class Homepage extends StatelessWidget {
  final IHttpService service;

  final String _url = 'https://blockchain.info/ticker';

  const Homepage(this.service);

  fetchCrypto(IHttpService service) {
    service.get(_url);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    fetchCrypto(service);
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('teste'),
        ),
      ),
    );
  }
}
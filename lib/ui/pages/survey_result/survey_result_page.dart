import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';

import '/ui/helpers/helpers.dart';


class SurveyResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Center(
        child: Text('Survey Result Page'),
      ),
    );
  }
}

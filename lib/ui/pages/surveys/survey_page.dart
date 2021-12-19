import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';

import '/ui/helpers/helpers.dart';

import 'components/components.dart';
import '/ui/pages/pages.dart';

class SurveysPage extends StatelessWidget {

  final SurveysPresenter surveysPresenter;

  const SurveysPage({@required this.surveysPresenter});

  @override
  Widget build(BuildContext context) {
    surveysPresenter.loadData();
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 1,
          ),
          items: [
            SurveyItem(),
            SurveyItem(),
            SurveyItem(),
          ],
        ),
      ),
    );
  }
}
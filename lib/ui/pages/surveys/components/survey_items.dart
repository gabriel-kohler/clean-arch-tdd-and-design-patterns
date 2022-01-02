import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

import '/ui/pages/pages.dart';

import 'survey_item.dart';

class SurveyItems extends StatelessWidget {

  final List<SurveyViewModel> listSurveys;

  const SurveyItems(this.listSurveys);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: CarouselSlider(
        options: CarouselOptions(
          enlargeCenterPage: true,
          aspectRatio: 1,
        ),
        items: listSurveys
            .map((survey) => SurveyItem(surveyViewModel: survey))
            .toList(),
      ),
    );
  }
}

import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:practice/ui/components/components.dart';

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
      body: Builder(
        builder: (context) {
          surveysPresenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });
          return Padding(
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
          );
        }
      ),
    );
  }
}
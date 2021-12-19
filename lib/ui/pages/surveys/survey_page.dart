import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';

import '/ui/components/components.dart';
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
      body: Builder(builder: (context) {
        surveysPresenter.isLoadingStream.listen((isLoading) {
          if (isLoading == true) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        return StreamBuilder<List<SurveyViewModel>>(
          stream: surveysPresenter.loadSurveysStream,
          builder: (context, snapshot) { 
            if (snapshot.hasError) {
              return Column(
                children: <Widget>[
                  Text(snapshot.error),
                  ElevatedButton(
                    onPressed: surveysPresenter.loadData,
                    child: Text(R.strings.reload),
                  ),
                ],
              );
            }
            if (snapshot.hasData) {
              final List<SurveyViewModel> listSurveys = snapshot.data;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    aspectRatio: 1,
                  ),
                  items: listSurveys.map((survey) => SurveyItem(survey: survey)).toList(),
                ),
              );
            }
            return SizedBox(height: 0);
          },
        );
      }),
    );
  }
}

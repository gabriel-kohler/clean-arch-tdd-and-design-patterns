import 'package:flutter/material.dart';

import '/ui/components/components.dart';
import '/ui/pages/pages.dart';
import '/ui/helpers/helpers.dart';

import 'components/components.dart';

class SurveyResultPage extends StatelessWidget {


  final SurveyResultPresenter surveyResultPresenter;

  SurveyResultPage({@required this.surveyResultPresenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (context) {
          surveyResultPresenter.isLoadingStream.listen((isLoading) { 
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });
          surveyResultPresenter.loadData();
          return StreamBuilder<SurveyResultViewModel>(
            stream: surveyResultPresenter.surveyResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(error: snapshot.error, reload: surveyResultPresenter.loadData);
              }
              if (snapshot.hasData) {
                return SurveyResult(surveyResultViewModel: snapshot.data);
              }
              return SizedBox(height: 0);
            }
          );
        }
      ),
    );
  }
}
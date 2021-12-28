import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/mixins/mixins.dart';
import '/ui/components/components.dart';
import '/ui/pages/pages.dart';
import '/ui/helpers/helpers.dart';

import 'components/components.dart';

import '/utils/utils.dart';

class SurveyResultPage extends StatelessWidget {
  final SurveyResultPresenter surveyResultPresenter;

  SurveyResultPage({@required this.surveyResultPresenter});

  @override
  Widget build(BuildContext context) {
    surveyResultPresenter.loadData();
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (context) {
          surveyResultPresenter.isSessionExpiredStream.listen((isExpired) {
            if (isExpired) {
              Get.offAllNamed(AppRoute.LoginPage);
            }
          });
          return StreamBuilder<SurveyResultViewModel>(
            stream: surveyResultPresenter.surveyResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error,
                  reload: surveyResultPresenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return SurveyResult(surveyResultViewModel: snapshot.data);
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
      ),
    );
  }
}

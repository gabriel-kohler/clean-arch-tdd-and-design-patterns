import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '/ui/helpers/helpers.dart';

import 'components/components.dart';
import '/ui/pages/pages.dart';
import '/ui/components/components.dart';

import '/utils/app_routes.dart';

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
          surveysPresenter.navigateToStream.listen((page) {
            if (page?.isNotEmpty == true) {
              Get.toNamed(page);
            }
          });
          surveysPresenter.isSessionExpiredStream.listen((isExpired) {
            if (isExpired) {
              Get.offAllNamed(AppRoute.LoginPage);
            }
          });
          return StreamBuilder<List<SurveyViewModel>>(
            stream: surveysPresenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error,
                  reload: surveysPresenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return Provider(
                  create:  (_) => surveysPresenter,
                  child: SurveyItems(listSurveys: snapshot.data),
                );
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

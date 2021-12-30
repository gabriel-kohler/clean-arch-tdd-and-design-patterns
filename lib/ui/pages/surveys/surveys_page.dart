import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '/ui/mixins/mixins.dart';
import '/ui/pages/pages.dart';
import '/ui/components/components.dart';
import '/ui/helpers/helpers.dart';

import 'components/components.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter surveysPresenter;

  const SurveysPage({@required this.surveysPresenter});

  @override
  State<SurveysPage> createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> with NavigationManager, SessionManager, RouteAware {

  @override
  void dispose() {
    Get.find<RouteObserver>().unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    widget.surveysPresenter.loadData();
    super.didPopNext();

  }

  @override
  Widget build(BuildContext context) {

    Get.find<RouteObserver>().subscribe(this, ModalRoute.of(context));
    
    widget.surveysPresenter.loadData();
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (context) {
          handleNavigation(widget.surveysPresenter.navigateToStream, clearNavigation: false);
          handleSession(widget.surveysPresenter.isSessionExpiredStream);
          return StreamBuilder<List<SurveyViewModel>>(
            stream: widget.surveysPresenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error,
                  reload: widget.surveysPresenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return Provider(
                  create:  (_) => widget.surveysPresenter,
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

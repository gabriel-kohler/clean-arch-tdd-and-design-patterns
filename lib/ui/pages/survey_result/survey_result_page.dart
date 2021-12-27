import 'package:flutter/material.dart';

import '/ui/pages/pages.dart';
import '/ui/helpers/helpers.dart';

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
          surveyResultPresenter.loadData();
          return ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    padding:
                        EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor.withAlpha(15),
                    ),
                    child: Text('Qual é o seu framework web favorito?'),
                  );
                }
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.network(
                            'http://fordevs.herokuapp.com/static/img/logo-angular.png',
                            width: 40,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                'Angular',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '100%',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(
                              Icons.check_circle,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1),
                  ],
                );
              });
        }
      ),
    );
  }
}

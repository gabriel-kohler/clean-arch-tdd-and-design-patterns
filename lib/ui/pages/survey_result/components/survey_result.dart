import 'package:flutter/material.dart';
import 'package:practice/ui/pages/pages.dart';

class SurveyResult extends StatelessWidget {

  final SurveyResultViewModel surveyResultViewModel;

  const SurveyResult({Key key, @required this.surveyResultViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: surveyResultViewModel.answers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            padding:
                EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withAlpha(15),
            ),
            child: Text(surveyResultViewModel.question),
          );
        }
        final surveyResult = surveyResultViewModel.answers[index - 1];
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
                        surveyResult.answer,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    surveyResult.percent,
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
}

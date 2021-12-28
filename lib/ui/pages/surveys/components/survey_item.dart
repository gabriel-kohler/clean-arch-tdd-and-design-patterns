import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/ui/pages/pages.dart';

class SurveyItem extends StatelessWidget {

  final SurveyViewModel surveyViewModel;

  const SurveyItem({@required this.surveyViewModel});

  @override
  Widget build(BuildContext context) {
    final surveysPresenter = Provider.of<SurveysPresenter>(context);
    return GestureDetector(
      onTap: () => surveysPresenter.goToSurveyResult(surveyViewModel.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surveyViewModel.didAnswer 
              ? Theme.of(context).primaryColorDark
              : Theme.of(context).secondaryHeaderColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                spreadRadius: 0,
                blurRadius: 2,
                color: Colors.black,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                surveyViewModel.date,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                surveyViewModel.question,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

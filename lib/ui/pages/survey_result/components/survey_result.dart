import 'package:flutter/material.dart';

import '/ui/pages/pages.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel surveyResultViewModel;

  const SurveyResult({Key key, @required this.surveyResultViewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: surveyResultViewModel.answers.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SurveyHeader(question: surveyResultViewModel.question);
          }
          final surveyResult = surveyResultViewModel.answers[index - 1];
          return SurveyAnswer(surveyResult: surveyResult);
        });
  }
}

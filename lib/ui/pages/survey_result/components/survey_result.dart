import 'package:flutter/material.dart';

import '/ui/pages/pages.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel surveyResultViewModel;
  final void Function({required String answer}) onSave;

  const SurveyResult({required this.surveyResultViewModel, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: surveyResultViewModel.answers.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SurveyHeader(surveyResultViewModel.question);
          }
          final surveyResult = surveyResultViewModel.answers[index - 1];
          return GestureDetector(
            onTap: () => surveyResult.isCurrentAnswer 
            ? null 
            : onSave(answer: surveyResult.answer),
            child: SurveyAnswer(surveyResult),
          );
        });
  }
}

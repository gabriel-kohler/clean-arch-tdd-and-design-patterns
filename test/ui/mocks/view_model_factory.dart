import 'package:practice/ui/pages/pages.dart';

class ViewModelFactory {

  static SurveyResultViewModel makeSurveyResultViewModel() => SurveyResultViewModel(
    surveyId: 'any_id', 
    question: 'Question', 
    answers: [
    SurveyAnswerViewModel(image: 'Image 0', answer: 'Answer 0', isCurrentAnswer: true, percent: '60%'),
    SurveyAnswerViewModel(answer: 'Answer 1', isCurrentAnswer: false, percent: '40%'),
    ],
  );

  static List<SurveyViewModel> makeSurveysViewModel() => [
    SurveyViewModel(id: '1', question: 'Question 1', date: 'Date1', didAnswer: true),
    SurveyViewModel(id: '2', question: 'Question 2', date: 'Date2', didAnswer: false),
  ];
}
import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:practice/ui/pages/pages.dart';

import 'view_model_factory.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {

  final surveyResultController = StreamController<SurveyResultViewModel>();
  final isSessionExpiredController = StreamController<bool>();

  SurveyResultPresenterSpy() {
    when(()  => this.loadData()).thenAnswer((_) async => _);
    when(()  => this.save(answer: any(named: 'answer'))).thenAnswer((_) async => _);
    when(() => this.surveyResultStream).thenAnswer((_) => surveyResultController.stream);
    when(() => this.isSessionExpiredStream).thenAnswer((_) => isSessionExpiredController.stream);
  }

  void dispose() {
    surveyResultController.close();
    isSessionExpiredController.close();
  }

  void emitSurveyResultValid() => surveyResultController.add(ViewModelFactory.makeSurveyResultViewModel());
  void emitSurveyResultError(String error) => surveyResultController.addError(error);

  void emitSessionExpired(bool isSession) => isSessionExpiredController.add(isSession);

}
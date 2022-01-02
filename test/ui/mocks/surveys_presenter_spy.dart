import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:practice/ui/pages/pages.dart';

import 'view_model_factory.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {

  final surveysController = StreamController<List<SurveyViewModel>>();
  final navigateToController = StreamController<String>();
  final isSessionExpiredController = StreamController<bool>();

  SurveysPresenterSpy() {
    when(()  => this.loadData()).thenAnswer((_) async => _);
    when(() => this.surveysStream).thenAnswer((_) => surveysController.stream);
    when(() => this.navigateToStream).thenAnswer((_) => navigateToController.stream);
    when(() => this.isSessionExpiredStream).thenAnswer((_) => isSessionExpiredController.stream);
  }

  void dispose() {
    surveysController.close();
    navigateToController.close();
    isSessionExpiredController.close();
  }

  void emitSurveysValid() => surveysController.add(ViewModelFactory.makeSurveysViewModel());
  void emitSurveysError(String error) => surveysController.addError(error);

  void emitSessionExpired(bool isSession) => isSessionExpiredController.add(isSession);

  void emitNavigateTo(String route) => navigateToController.add(route);

}
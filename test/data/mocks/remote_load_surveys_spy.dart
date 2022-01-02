import 'package:mocktail/mocktail.dart';

import 'package:practice/data/usecases/usecases.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/helpers/helpers.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {

  When mockLoadCall() => when(() => this.load());
  void mockLoad(List<SurveyEntity> surveys) => this.mockLoadCall().thenAnswer((_) async => surveys);
  void mockLoadError(DomainError error) => this.mockLoadCall().thenThrow(error);
}
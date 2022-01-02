import 'package:mocktail/mocktail.dart';

import 'package:practice/data/usecases/usecases.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/helpers/helpers.dart';

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {

  LocalLoadSurveysSpy() {
    this.mockValidate();
    this.mockSave();
  }

  When mockLoadCall() => when(() => this.load());  
  void mockLoad(List<SurveyEntity> surveys) => this.mockLoadCall().thenAnswer((_) async => surveys);
  void mockLoadError () => this.mockLoadCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => this.validate());
  void mockValidate() => this.mockValidateCall().thenAnswer((_) async => _);
  void mockValidateError() => this.mockValidateCall().thenThrow(Exception());

  When mockSaveCall() => when(() => this.save(any()));
  void mockSave() => this.mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => this.mockSaveCall().thenThrow(Exception());
   
}
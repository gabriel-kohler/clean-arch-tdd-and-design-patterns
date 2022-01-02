import 'package:mocktail/mocktail.dart';
import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/usecases/usecases.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {

  When mockLoadCurrentAccountCall() => when(() => this.fetch());
  void mockLoadCurrentAccount({required String account}) => this.mockLoadCurrentAccountCall().thenAnswer((_) async => AccountEntity(account));
  void mockLoadCurrentAccountError() => this.mockLoadCurrentAccountCall().thenThrow(Exception());

}
import 'package:mocktail/mocktail.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/domain/usecases/usecases.dart';

class AddAccountSpy extends Mock implements AddAccount {

  When mockAddAccountCall() => when(() => this.add(params: any(named: 'params')));
  void mockAddAccount(AccountEntity data) => this.mockAddAccountCall().thenAnswer((_) async => data);
  void mockAddAccountError(DomainError error) => this.mockAddAccountCall().thenThrow(error);

}
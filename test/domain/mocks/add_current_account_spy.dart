import 'package:mocktail/mocktail.dart';

import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/domain/usecases/usecases.dart';

class AddCurrentAccountSpy extends Mock implements AddCurrentAccount {

  AddCurrentAccountSpy() {
    this.mockSaveCurrentAccount();
  }

  When mockSaveCurrentAccountCall() => when(() => this.save(account: any(named: 'account')));
  void mockSaveCurrentAccount() => this.mockSaveCurrentAccountCall().thenAnswer((_) async => _);
  void mockSaveCurrentAccountError() => this.mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  
}
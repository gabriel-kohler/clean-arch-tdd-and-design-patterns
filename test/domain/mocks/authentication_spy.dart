import 'package:mocktail/mocktail.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/domain/helpers/helpers.dart';
import 'package:practice/domain/usecases/usecases.dart';

class AuthenticationSpy extends Mock implements Authentication {

  When mockAuthenticationCall() => when(() => this.auth(params: any(named: 'params')));
  void mockAuthentication(AccountEntity data) => this.mockAuthenticationCall().thenAnswer((_) async => data);
  void mockAuthenticationError(DomainError error) => this.mockAuthenticationCall().thenThrow(error);

}
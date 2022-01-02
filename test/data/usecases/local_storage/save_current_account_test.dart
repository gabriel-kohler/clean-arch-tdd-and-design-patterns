import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:test/test.dart';

import 'package:practice/domain/entities/account_entity.dart';
import 'package:practice/domain/helpers/domain_error.dart';
import 'package:practice/data/cache/cache.dart';
import 'package:practice/data/usecases/usecases.dart';

class SaveSecureCurrentAccountSpy extends Mock implements SaveSecureCurrentAccount {}

void main() {

  late SaveSecureCurrentAccount saveSecureCurrentAccountSpy;
  late SaveCurrentAccount sut;
  late AccountEntity account;

  setUp(() {
    saveSecureCurrentAccountSpy = SaveSecureCurrentAccountSpy();
    sut = SaveCurrentAccount(saveSecureCurrentAccount: saveSecureCurrentAccountSpy);

    account = AccountEntity(faker.guid.guid());
  });

  test('ensure SaveCurrentAccount call SaveSecureCurrentAccount with correct values', () async {

    await sut.save(account: account);

    verify(() => (saveSecureCurrentAccountSpy.saveSecure(key: 'token', value: account.token))).called(1);
  });
  
  test('ensure SaveCurrentAccount throw UnexpectedError if SaveSecureCurrentAccount throws', () async {

    when(() => (saveSecureCurrentAccountSpy.saveSecure(key: any(named: 'key'), value: any(named: 'value')))).thenThrow(Exception());

    final future = sut.save(account: account);

    expect(future, throwsA(DomainError.unexpected));
    
  });
}
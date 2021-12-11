import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/domain/helpers/domain_error.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:practice/domain/entities/account_entity.dart';
import 'package:practice/domain/usecases/load_current_account.dart';

abstract class FetchSecureCurrentAccount {
  Future<String> fetchSecure({@required String key});
}

class FetchSecureCurrentAccountSpy extends Mock implements FetchSecureCurrentAccount {}

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCurrentAccount fetchSecureCurrentAccount;

  LocalLoadCurrentAccount({@required this.fetchSecureCurrentAccount});

  Future<AccountEntity> fetch() async {
    try {
      final account = await fetchSecureCurrentAccount.fetchSecure(key: 'token');
      return AccountEntity(account);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

}
void main() {

  FetchSecureCurrentAccount fetchSecureCurrentAccountSpy;
  LocalLoadCurrentAccount sut;
  String token;

  setUp(() {
    fetchSecureCurrentAccountSpy = FetchSecureCurrentAccountSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCurrentAccount: fetchSecureCurrentAccountSpy);
    token = faker.guid.guid();

  });

  test('Should call FetchSecureCurrentAccount with correct values', () async {

    await sut.fetch();

    verify(fetchSecureCurrentAccountSpy.fetchSecure(key: 'token')).called(1);

  });

  test('Should return AccountEntity if FetchSecure success', () async {

    when(fetchSecureCurrentAccountSpy.fetchSecure(key: anyNamed('key'))).thenAnswer((_) async => token);

    final account = await sut.fetch();

    expect(account, AccountEntity(token));
  });

  test('Should LocalLoadCurrentAccount throw UnexpectedError if FetchSecure throws', () async {

    when(fetchSecureCurrentAccountSpy.fetchSecure(key: anyNamed('key'))).thenThrow(Exception());

    final future = sut.fetch ();

    expect(future, throwsA(DomainError.unexpected));
    
  });

}
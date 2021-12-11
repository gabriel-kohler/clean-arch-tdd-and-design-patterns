import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:practice/domain/entities/account_entity.dart';
import 'package:practice/domain/helpers/domain_error.dart';

import 'package:practice/data/cache/cache.dart';
import 'package:practice/data/usecases/usecases.dart';


class FetchSecureCurrentAccountSpy extends Mock implements FetchSecureCurrentAccount {}

void main() {

  FetchSecureCurrentAccount fetchSecureCurrentAccountSpy;
  LocalLoadCurrentAccount sut;
  String token;

  setUp(() {
    fetchSecureCurrentAccountSpy = FetchSecureCurrentAccountSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCurrentAccount: fetchSecureCurrentAccountSpy);
    token = faker.guid.guid();

  });

  mockFetchSecureCall() => when(fetchSecureCurrentAccountSpy.fetchSecure(key: anyNamed('key')));

  mockFetchSecure() => mockFetchSecureCall().thenAnswer((_) async => token);

  mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

  test('Should call FetchSecureCurrentAccount with correct values', () async {

    await sut.fetch();

    verify(fetchSecureCurrentAccountSpy.fetchSecure(key: 'token')).called(1);

  });

  test('Should return AccountEntity if FetchSecure success', () async {

    mockFetchSecure();

    final account = await sut.fetch();

    expect(account, AccountEntity(token));
  });

  test('Should LocalLoadCurrentAccount throw UnexpectedError if FetchSecure throws', () async {

    mockFetchSecureError();

    final future = sut.fetch ();

    expect(future, throwsA(DomainError.unexpected));
    
  });

}
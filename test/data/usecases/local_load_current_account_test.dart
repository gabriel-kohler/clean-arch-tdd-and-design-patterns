import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

abstract class FetchSecureCurrentAccount {
  Future<String> fetchSecure({@required String key});
}

class FetchSecureCurrentAccountSpy extends Mock implements FetchSecureCurrentAccount {}

class LocalLoadCurrentAccount {
  final FetchSecureCurrentAccount fetchSecureCurrentAccount;

  LocalLoadCurrentAccount({@required this.fetchSecureCurrentAccount});

  Future<void> fetch() async {
    await fetchSecureCurrentAccount.fetchSecure(key: 'token');
  }

}
void main() {

  FetchSecureCurrentAccount fetchSecureCurrentAccountSpy;
  LocalLoadCurrentAccount sut;

  setUp(() {
    fetchSecureCurrentAccountSpy = FetchSecureCurrentAccountSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCurrentAccount: fetchSecureCurrentAccountSpy);
  });

  test('Should call FetchSecureCurrentAccount with correct values', () async {

    await sut.fetch();

    verify(fetchSecureCurrentAccountSpy.fetchSecure(key: 'token')).called(1);

  });
}
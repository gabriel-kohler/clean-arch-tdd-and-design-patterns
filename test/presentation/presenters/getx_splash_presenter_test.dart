import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:practice/domain/usecases/load_current_account.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

class GetxSplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});

  Future<void> loadAccount() async {
    await loadCurrentAccount.fetch();
  }

}
void main() {

  test('Should SplashPresenter calls LoadCurrentAccount with correct values', () async {
    final loadCurrentAccountSpy = LoadCurrentAccountSpy();
    final sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccountSpy);

    await sut.loadAccount();

    verify(loadCurrentAccountSpy.fetch()).called(1);
  });
}
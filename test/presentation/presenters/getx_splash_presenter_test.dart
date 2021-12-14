import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:practice/domain/entities/entities.dart';
import 'package:practice/ui/pages/pages.dart';
import 'package:practice/utils/app_routes.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:practice/domain/usecases/load_current_account.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});

  var _navigateTo = RxString(null);
  
  @override
  Stream<String> get navigateToStream => _navigateTo.stream;

  Future<void> checkAccount() async {

    try {
      final account = await loadCurrentAccount.fetch();

      if (account.token == null) {
        _navigateTo.value = AppRoute.LoginPage;
      } else {
        _navigateTo.value = AppRoute.HomePage;
      }

    } catch (error) {
      _navigateTo.value = AppRoute.LoginPage;
    }

  }

}
void main() {

  LoadCurrentAccountSpy loadCurrentAccountSpy;
  GetxSplashPresenter sut;

  setUp(() {
    loadCurrentAccountSpy = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccountSpy);
  });

  PostExpectation mockLoadCurrentAccountCall() => when(loadCurrentAccountSpy.fetch());

  void mockLoadCurrentAccount(String account) => mockLoadCurrentAccountCall().thenAnswer((_) => AccountEntity(account));

  void mockLoadCurrentAccountError() => mockLoadCurrentAccountCall().thenThrow(Exception());

  test('Should SplashPresenter calls LoadCurrentAccount with correct values', () async {
    
    mockLoadCurrentAccount('any_token');

    await sut.checkAccount();

    verify(loadCurrentAccountSpy.fetch()).called(1);
  });

  test('Should SplashPresenter navigate to home page if have token in cache', () async {

    when(loadCurrentAccountSpy.fetch()).thenAnswer((_) async => AccountEntity('any_token'));

    sut.navigateToStream.listen(
      expectAsync1((page) {
        expect(page, AppRoute.HomePage);
      })
    );

    await sut.checkAccount();

  });

  test('Should SplashPresenter navigate to login page if there is no token in cache', () async {

    when(loadCurrentAccountSpy.fetch()).thenAnswer((_) async => AccountEntity(null));

    sut.navigateToStream.listen(
      expectAsync1((page) {
        expect(page, AppRoute.LoginPage);
      })
    );

    await sut.checkAccount();

  });

  test('Should go to login page on error', () async {
    when(loadCurrentAccountSpy.fetch()).thenThrow(Exception());

    sut.navigateToStream.listen(
      expectAsync1((page) {   
        expect(page, AppRoute.LoginPage);
      })
    );

    await sut.checkAccount();
  });

}
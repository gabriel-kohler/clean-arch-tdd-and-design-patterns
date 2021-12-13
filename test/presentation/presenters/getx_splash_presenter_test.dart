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
    await loadCurrentAccount.fetch();
    _navigateTo.value = AppRoute.HomePage;
  }

}
void main() {

  LoadCurrentAccountSpy loadCurrentAccountSpy;
  GetxSplashPresenter sut;

  setUp(() {
    loadCurrentAccountSpy = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccountSpy);
  });

  test('Should SplashPresenter calls LoadCurrentAccount with correct values', () async {
    
    await sut.checkAccount();

    verify(loadCurrentAccountSpy.fetch()).called(1);
  });

  test('Should SplashPresenter navigate to home page if have token', () async {

    when(loadCurrentAccountSpy.fetch()).thenAnswer((_) async => AccountEntity('any_token'));

    sut.navigateToStream.listen(
      expectAsync1((page) {
        expect(page, AppRoute.HomePage);
      })
    );

    await sut.checkAccount();

  });

}
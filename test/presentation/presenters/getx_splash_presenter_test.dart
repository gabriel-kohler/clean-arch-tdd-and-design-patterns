import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:practice/utils/app_routes.dart';

import 'package:practice/presentation/presenters/presenters.dart';

import '../../domain/mocks/mocks.dart';

void main() {

  late LoadCurrentAccountSpy loadCurrentAccountSpy;
  late GetxSplashPresenter sut;

  setUp(() {
    loadCurrentAccountSpy = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccountSpy);
  });


  test('Should SplashPresenter calls LoadCurrentAccount with correct values', () async {
    
    loadCurrentAccountSpy.mockLoadCurrentAccount(account: 'any_token');

    await sut.checkAccount();

    verify(() => (loadCurrentAccountSpy.fetch())).called(1);
  });

  test('Should SplashPresenter navigate to home page if have token in cache', () async {

    loadCurrentAccountSpy.mockLoadCurrentAccount(account: 'any_token');

    sut.navigateToStream.listen(
      expectAsync1((page) {
        expect(page, AppRoute.SurveysPage); 
      })
    );

    await sut.checkAccount();

  });

  test('Should go to login page on error', () async {
    
    loadCurrentAccountSpy.mockLoadCurrentAccountError();

    sut.navigateToStream.listen(
      expectAsync1((page) {   
        expect(page, AppRoute.LoginPage);
      })
    );

    await sut.checkAccount();
  });

}
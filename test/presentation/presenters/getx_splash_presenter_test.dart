import 'package:mockito/mockito.dart';
import 'package:practice/domain/usecases/usecases.dart';
import 'package:test/test.dart';

import 'package:practice/utils/app_routes.dart';

import 'package:practice/domain/entities/entities.dart';
import 'package:practice/presentation/presenters/presenters.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}
void main() {

  LoadCurrentAccountSpy loadCurrentAccountSpy;
  GetxSplashPresenter sut;

  setUp(() {
    loadCurrentAccountSpy = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccountSpy);
  });

  PostExpectation mockLoadCurrentAccountCall() => when(loadCurrentAccountSpy.fetch());

  void mockLoadCurrentAccount(String account) => mockLoadCurrentAccountCall().thenAnswer((_)async => AccountEntity(account));

  void mockLoadCurrentAccountError() => mockLoadCurrentAccountCall().thenThrow(Exception());

  test('Should SplashPresenter calls LoadCurrentAccount with correct values', () async {
    
    mockLoadCurrentAccount('any_token');

    await sut.checkAccount();

    verify(loadCurrentAccountSpy.fetch()).called(1);
  });

  test('Should SplashPresenter navigate to home page if have token in cache', () async {

    mockLoadCurrentAccount('any_token');

    sut.navigateToStream.listen(
      expectAsync1((page) {
        expect(page, AppRoute.SurveysPage); 
      })
    );

    await sut.checkAccount();

  });

  test('Should SplashPresenter navigate to login page if there is no token in cache', () async {

    mockLoadCurrentAccount(null);

    sut.navigateToStream.listen(
      expectAsync1((page) {
        expect(page, AppRoute.LoginPage);
      })
    );

    await sut.checkAccount();

  });

  test('Should go to login page on error', () async {
    
    mockLoadCurrentAccountError();

    sut.navigateToStream.listen(
      expectAsync1((page) {   
        expect(page, AppRoute.LoginPage);
      })
    );

    await sut.checkAccount();
  });

}
import 'package:mocktail/mocktail.dart';
import 'dart:async';

import 'package:practice/ui/pages/pages.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {
  final navigateToController = StreamController<String>();

  SplashPresenterSpy() {
    when(()  => this.checkAccount()).thenAnswer((_) async => _);
    when(() => this.navigateToStream).thenAnswer((_) => navigateToController.stream);  
  }

  void dispose() {
    navigateToController.close();
  }

  void emitNavigateTo(String route) => navigateToController.add(route);
}
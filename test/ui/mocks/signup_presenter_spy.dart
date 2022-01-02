import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:practice/ui/helpers/helpers.dart';

import 'package:practice/ui/pages/pages.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {

  final nameErrorController = StreamController<UIError?>();
  final emailErrorController = StreamController<UIError?>();
  final passwordErrorController = StreamController<UIError?>();
  final confirmPasswordErrorController = StreamController<UIError?>();
  final mainErrorController = StreamController<UIError?>();
  final isFormValidController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();
  final navigateToController = StreamController<String>();

  SignUpPresenterSpy() {
    when(()  => this.signUp()).thenAnswer((_) async => _);
    when(() => this.nameErrorStream).thenAnswer((_) => nameErrorController.stream);  
    when(() => this.emailErrorStream).thenAnswer((_) => emailErrorController.stream);    
    when(() => this.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(() => this.confirmPasswordErrorStream).thenAnswer((_) => confirmPasswordErrorController.stream);
    when(() => this.isFormValidStream).thenAnswer((_) => isFormValidController.stream);    
    when(() => this.isLoadingStream).thenAnswer((_) => isLoadingController.stream);    
    when(() => this.mainErrorStream).thenAnswer((_) => mainErrorController.stream);
    when(() => this.navigateToStream).thenAnswer((_) => navigateToController.stream);
  }

  void dispose() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    confirmPasswordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }

  void emitNameError(UIError error) => nameErrorController.add(error);
  void emitNameValid() => nameErrorController.add(null);

  void emitEmailError(UIError error) => emailErrorController.add(error);
  void emitEmailValid() => emailErrorController.add(null);

  void emitPasswordError(UIError error) => passwordErrorController.add(error);
  void emitPasswordValid() => passwordErrorController.add(null);

  void emitConfirmPasswordError(UIError error) => confirmPasswordErrorController.add(error);
  void emitConfirmPasswordValid() => confirmPasswordErrorController.add(null);

  void emitFormError() => isFormValidController.add(false);
  void emitFormValid() => isFormValidController.add(true);

  void emitLoading([bool isLoading = true]) => isLoadingController.add(isLoading);

  void emitMainError(UIError mainError) => mainErrorController.add(mainError);

  void emitNavigateTo(String route) => navigateToController.add(route);

}
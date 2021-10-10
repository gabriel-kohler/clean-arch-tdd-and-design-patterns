abstract class LoginPresenter {

  Stream<String> get emailErrorStream;
  Stream<String> get passsowrdErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  void validateEmail(String email);
  void validatePassword(String password);
  void auth();
}
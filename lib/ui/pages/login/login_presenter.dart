abstract class LoginPresenter {

  Stream<String> get emailErrorStream;
  Stream<String> get passsowrdErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;
  Stream<String> get mainErrorStream;

  void validateEmail(String email);
  void validatePassword(String password);
  void auth();
  void dispose();
}
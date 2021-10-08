abstract class LoginPresenter {

  Stream get emailErrorStream;
  Stream get passsowrdErrorStream;
  Stream get isFormValidStream;

  void validateEmail(String email);
  void validatePassword(String password);
  void auth();
}
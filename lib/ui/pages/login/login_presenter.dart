abstract class LoginPresenter {

  Stream get emailErrorStream;
  Stream get passsowrdErrorStream;

  void validateEmail(String email);
  void validatePassword(String password);
}
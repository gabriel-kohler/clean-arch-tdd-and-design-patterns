abstract class LoginPresenter {

  Stream get emailErrorStream;
  Stream get passsowrdErrorStream;
  Stream get isFormValid;

  void validateEmail(String email);
  void validatePassword(String password);
}
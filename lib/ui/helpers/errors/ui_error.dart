enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials:
        return 'Credenciais inválidas';
      case UIError.invalidField:
        return 'Campo inválido';
      case UIError.requiredField:
        return 'Campo obrigatório';
      default:
        return 'Ocorreu um erro. Tente novamente em breve';
    }
  }
}

import 'package:practice/data/models/remote_account_model.dart';

import '/domain/helpers/helpers.dart';
import '/domain/usecases/usecases.dart';
import '/domain/entities/entities.dart';

import '/data/http/http.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<AccountEntity> auth({required AuthenticationParams params}) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
       final httpResponse = await httpClient.request(url: url, method: 'post', body: body);
       return RemoteAccountModel.fromJson(httpResponse).toAccountEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      new RemoteAuthenticationParams(
          email: params.email, password: params.password);

  Map toJson() => {'email': email, 'password': password};
}

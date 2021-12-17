import 'package:meta/meta.dart';

import '/data/http/http.dart';
import '/data/models/models.dart';
 
import '/domain/entities/entities.dart';
import '/domain/helpers/helpers.dart';
import '/domain/usecases/usecases.dart';

class RemoteAddAccount implements AddAccount {

  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({@required this.httpClient, @required this.url});

  Future<AccountEntity> add({@required AddAccountParams params}) async {

    final body = RemoteAddAccountParams.fromDomain(params).toJson();

    try {
      final account = await httpClient.request(url: url, method: 'post', body: body);
      return RemoteAccountModel.fromJson(account).toAccountEntity();
    } on HttpError catch (error) {
      if (error == HttpError.forbidden) {
        throw DomainError.emainInUse;
      } else {
        throw DomainError.unexpected;
      }
    }

  }
}

class RemoteAddAccountParams {
  final AddAccountParams params;

  RemoteAddAccountParams({@required this.params});

  factory RemoteAddAccountParams.fromDomain(AddAccountParams params) => RemoteAddAccountParams(params: params);

  toJson() => {
    'name' : params.name,
    'email' : params.email,
    'password' : params.password,
    'confirmPassword' : params.confirmPassowrd,
  };

}
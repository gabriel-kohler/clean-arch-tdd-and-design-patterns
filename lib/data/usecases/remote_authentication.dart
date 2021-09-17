
import '../../domain/usecases/authentication.dart';

import '../../data/http/http.dart';

class RemoteAuthentication {
  final HttpClient? httpClient;
  final String? url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void>? auth(AuthenticationParams params) async {
    final body = {
      'email': params.email,
      'password': params.password,
    };

    await httpClient!.request(url: url, method: 'post', body: body);
  }
}
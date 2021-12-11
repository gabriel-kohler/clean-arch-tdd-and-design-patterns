import '/data/usecases/remote_authentication.dart';

import '../factories.dart';

RemoteAuthentication makeRemoteAuthentication() {
  final url = 'http://fordevs.herokuapp.com/api/login';
  return RemoteAuthentication(
    httpClient: makeHttpAdapter(),
    url: url,
  );
}
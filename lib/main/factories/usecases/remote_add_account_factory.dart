import '/data/usecases/usecases.dart';

import '/domain/usecases/usecases.dart';

import '/main/factories/factories.dart';

AddAccount makeRemoteAddAccount() {
  return RemoteAddAccount(httpClient: makeHttpAdapter(), url: makeApiUrl('signup'));
}
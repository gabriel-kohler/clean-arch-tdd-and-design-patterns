import '/data/http/http.dart';

import '/main/decorators/decorators.dart';
import '/main/factories/factories.dart';

HttpClient makeAuthorizeHttpClientDecorator() => AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: makeSecureStorageAdapter(),
      decoratee: makeHttpAdapter(),
      deleteSecureCacheStorage: null,
    );

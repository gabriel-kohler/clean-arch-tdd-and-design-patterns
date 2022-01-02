import 'package:mocktail/mocktail.dart';

import 'package:practice/data/cache/cache.dart';


class SecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage, DeleteSecureCacheStorage, SaveSecureCacheStorage {

  SecureCacheStorageSpy() {
    this.mockDeleteSecure();
    this.mockSaveSecure();
  }

  mockFetchSecureCall() => when(() => this.fetchSecure(key: any(named: 'key')));
  mockFetchSecure(String? data) => this.mockFetchSecureCall().thenAnswer((_) async => data);
  mockFetchSecureError() => this.mockFetchSecureCall().thenThrow(Exception());

  When mockDeleteSecureCall() => when(() => this.deleteSecure(key: any(named: 'key')));
  void mockDeleteSecure() => mockDeleteSecureCall().thenAnswer((_) async => _);
  void mockDeleteSecureError() => mockDeleteSecureCall().thenThrow(Exception());

  When mockSaveSecureCall() => when(() => this.saveSecure(key: any(named: 'key'), value: any(named: 'value')));
  void mockSaveSecure() => this.mockSaveSecureCall().thenAnswer((_) async => _);
  void mockSaveSecureError() => this.mockSaveSecureCall().thenThrow(Exception());


}
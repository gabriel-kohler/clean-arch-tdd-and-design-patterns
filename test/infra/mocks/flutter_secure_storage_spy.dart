import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:mocktail/mocktail.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {

  
  When mockSaveSecureCall() => when(() => this.write(key: any(named: 'key'), value: any(named: 'value')));
  mockSaveSecure() => mockSaveSecureCall().thenAnswer((_) async => _);
  mockSaveSecureError() => mockSaveSecureCall().thenThrow(Exception());


  When mockFetchSecureCall() => when(() => this.read(key: any(named: 'key')));
  mockFetchSecure(String? data) => mockFetchSecureCall().thenAnswer((_) async => data);
  mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

  When mockDeleteSecureCall() => when(() => this.delete(key: any(named: 'key')));
  mockDeleteSecure() => mockDeleteSecureCall().thenAnswer((_) async => _);
  mockDeleteSecureError() => mockDeleteSecureCall().thenThrow(Exception());
}
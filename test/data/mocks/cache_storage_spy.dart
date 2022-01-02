import 'package:mocktail/mocktail.dart';

import 'package:practice/data/cache/cache.dart';


class CacheStorageSpy extends Mock implements CacheStorage {

  CacheStorageSpy() {
    this.mockDelete();
    this.mockSave();
  }

  When mockFetchCall() => when(() => this.fetch(key: any(named: 'key')));
  void mockFetchData(dynamic json) => mockFetchCall().thenAnswer((_) async => json);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  When mockDeleteCall() => when(() => this.delete(key: any(named: 'key')));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteError() => mockDeleteCall().thenThrow(Exception());

  When mockSaveCall() => when(() => this.save(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());

}
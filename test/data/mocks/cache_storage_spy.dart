import 'package:mocktail/mocktail.dart';

import 'package:practice/data/cache/cache.dart';


class CacheStorageSpy extends Mock implements CacheStorage {

  CacheStorageSpy() {
    mockDelete();
    mockSave();
  }

  When mockFetchCall() => when(() => fetch(key: any(named: 'key')));
  void mockFetchData(Map json) => mockFetchCall().thenAnswer((_) async => json);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  When mockDeleteCall() => when(() => delete(key: any(named: 'key')));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteError() => mockDeleteCall().thenThrow(Exception());

  When mockSaveCall() => when(() => save(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());

  Future<void> delete({required String key});
  Future<void> save({required String key, required dynamic value});
}
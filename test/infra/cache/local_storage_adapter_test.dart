import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:localstorage/localstorage.dart';

import 'package:practice/infra/cache/cache.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {

  late String key;
  late dynamic value;

  late LocalStorageAdapter sut;
  late LocalStorage localStorageSpy;

  setUp(() {
    key = faker.randomGenerator.string(4);
    value = faker.randomGenerator.string(30);

    localStorageSpy = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorageSpy);
  });

  void mockDeleteItemError() => when(() => (localStorageSpy.deleteItem(any()))).thenThrow(Exception());

  void mockSaveItemError() => when(() => (localStorageSpy.setItem(any(), any))).thenThrow(Exception());

  

  group('save', () {
    test('Should LocalStorageAdapter calls save with correct values', () async {
    
      await sut.save(key: key, value: value);

      verify(() => (localStorageSpy.deleteItem(key))).called(1);
      verify(() => (localStorageSpy.setItem(key, value))).called(1);

    });

    test('Should throw if deleteItem throws', () async {

      mockDeleteItemError();
    
      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));

    });

    test('Should throw if save throws', () async {

      mockSaveItemError();
    
      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));

    });

  });

  group('delete', () {
    
    test('Should LocalStorageAdapter calls delete cache with correct key', () async {
       await sut.delete(key: key);

      verify(() => (localStorageSpy.deleteItem(key))).called(1);
    });

    test('Should throw if delete throws', () async {

      mockDeleteItemError();
    
      final future = sut.delete(key: key);

      expect(future, throwsA(TypeMatcher<Exception>()));

    });

  });

  group('fetch', () {

    late String result;

    When mockFetchCall() => when(() => (localStorageSpy.getItem(any())));

    void mockFetch() => mockFetchCall().thenAnswer((_) async => result);
    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      result = faker.randomGenerator.string(30);
    });

    test('Should LocalStorageAdapter calls fetch with correct key', () async {
       await sut.fetch(key: key);

      verify(() => (localStorageSpy.getItem(key))).called(1);
    });

    test('Should return same as localStorage ', () async {

      mockFetch();

      final data = await sut.fetch(key: key);

      expect(data, result);
    });

    test('Should throw if fetch throws', () async {

      mockFetchError();
    
      final future = sut.fetch(key: key);

      expect(future, throwsA(TypeMatcher<Exception>()));

    });

  });

  
}
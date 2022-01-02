import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:practice/infra/cache/cache.dart';

import '../mocks/mocks.dart';



void main() {

  late String key;
  late dynamic value;

  late LocalStorageAdapter sut;
  late LocalStorageSpy localStorageSpy;

  setUp(() {
    key = faker.randomGenerator.string(4);
    value = faker.randomGenerator.string(30);

    localStorageSpy = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorageSpy);
  });


  group('save', () {
    test('Should LocalStorageAdapter calls save with correct values', () async {
    
      await sut.save(key: key, value: value);

      verify(() => (localStorageSpy.deleteItem(key))).called(1);
      verify(() => (localStorageSpy.setItem(key, value))).called(1);

    });

    test('Should throw if deleteItem throws', () async {

      localStorageSpy.mockDeleteError();
    
      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));

    });

    test('Should throw if save throws', () async {

      localStorageSpy.mockSaveError();
    
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

      localStorageSpy.mockDeleteError();
    
      final future = sut.delete(key: key);

      expect(future, throwsA(TypeMatcher<Exception>()));

    });

  });

  group('fetch', () {

    late String result;

    setUp(() {
      result = faker.randomGenerator.string(30);
    });

    test('Should LocalStorageAdapter calls fetch with correct key', () async {
       await sut.fetch(key: key);

      verify(() => (localStorageSpy.getItem(key))).called(1);
    });

    test('Should return same as localStorage ', () async {

      localStorageSpy.mockFetch(result);

      final data = await sut.fetch(key: key);

      expect(data, result);
    });

    test('Should throw if fetch throws', () async {

      localStorageSpy.mockFetchError();
    
      final future = sut.fetch(key: key);

      expect(future, throwsA(TypeMatcher<Exception>()));

    });

  });

  
}
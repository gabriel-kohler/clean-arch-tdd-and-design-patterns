import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:localstorage/localstorage.dart';

import 'package:practice/domain/entities/entities.dart';


class LocalStorageAdapter {

  final LocalStorage localStorage;

  LocalStorageAdapter({@required this.localStorage});

  Future<void> save({@required String key, @required dynamic value}) async {
    await localStorage.setItem(key, value);
  }
}

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {

  test('Should LocalStorageAdapter calls save with correct values', () async {
    final key = faker.randomGenerator.string(4);
    final value = faker.randomGenerator.string(30);

    final localStorageSpy = LocalStorageSpy();
    final sut = LocalStorageAdapter(localStorage: localStorageSpy);

    
    await sut.save(key: key, value: value);

    verify(localStorageSpy.setItem(key, value)).called(1);

  });
}
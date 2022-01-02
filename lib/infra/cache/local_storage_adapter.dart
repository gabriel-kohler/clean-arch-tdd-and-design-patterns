import 'package:localstorage/localstorage.dart';



import '/data/cache/cache.dart';

class LocalStorageAdapter implements CacheStorage {

  final LocalStorage localStorage;

  LocalStorageAdapter({required this.localStorage});

  Future<void> save({required String key, required dynamic value}) async {
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }

  Future<void> delete({required String key}) async {
    await localStorage.deleteItem(key);
  }

  Future<dynamic> fetch({required String key}) async {
    return await localStorage.getItem(key);
  }
}
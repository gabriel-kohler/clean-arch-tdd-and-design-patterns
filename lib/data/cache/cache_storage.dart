import 'package:meta/meta.dart';

abstract class CacheStorage {
  Future<dynamic> fetch({@required String key});
  Future<void> delete({@required String key});
  Future<void> save({@required String key, @required dynamic value});
}
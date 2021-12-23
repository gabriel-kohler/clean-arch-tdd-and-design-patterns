import 'package:meta/meta.dart';

abstract class CacheStorage {
  Future<dynamic> fetch({@required key});
}
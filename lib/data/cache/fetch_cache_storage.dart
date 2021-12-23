import 'package:meta/meta.dart';

abstract class FetchCacheStorage {
  Future<dynamic> fetch({@required key});
}
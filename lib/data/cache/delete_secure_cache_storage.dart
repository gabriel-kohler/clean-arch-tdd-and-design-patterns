import 'package:meta/meta.dart';

abstract class DeleteSecureCacheStorage {
  Future<void> deleteSecure({@required String key});
}
import 'package:meta/meta.dart';

abstract class FetchSecureCurrentAccount {
  Future<String> fetchSecure({@required String key});
}
import 'package:meta/meta.dart';

abstract class SaveSecureCurrentAccount {
  Future<void> saveSecure({@required String key, @required String value});
}
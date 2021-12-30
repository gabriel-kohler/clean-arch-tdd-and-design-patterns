import 'package:faker/faker.dart';

class FakeAccountFactory {

  static Map makeApiJson() => {'accessToken' : faker.guid.guid(), 'name': faker.person.name()};

}

import 'package:faker/faker.dart';
import 'package:practice/domain/entities/entities.dart';

class FakeAccountFactory {

  static Map makeApiJson() => {'accessToken' : faker.guid.guid(), 'name': faker.person.name()};

  static AccountEntity makeAccountEntity() => AccountEntity(faker.guid.guid());

}

import 'package:faker/faker.dart';

import 'package:practice/domain/usecases/usecases.dart';

class FakeParamsFactory {
  static AddAccountParams makeAddAccountParams() => AddAccountParams(
      email: faker.internet.email(), 
      password: faker.internet.password(), 
      confirmPassowrd: faker.internet.password(), 
      name: faker.person.name(),
    );

    static AuthenticationParams makeAuthenticationParams() => AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
}


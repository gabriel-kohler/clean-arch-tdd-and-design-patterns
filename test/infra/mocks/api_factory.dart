import 'package:faker/faker.dart';

class ApiFactory {

  static Map makeAccountJson() => {'accessToken' : faker.guid.guid(), 'name': faker.person.name()};

  static List<Map> makeSurveyList() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': faker.date.dateTime().toIso8601String(),
          'didAnswer': false,
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': faker.date.dateTime().toIso8601String(),
          'didAnswer': false,
        },
      ];

  static Map makeSurveyResultJson() => {
    'surveyId': faker.guid.guid(),
    'question': faker.randomGenerator.string(10),
    'date': faker.date.dateTime().toIso8601String(),
    'answers': [{
      'image': faker.internet.httpUrl(),
      'answer': faker.randomGenerator.string(20),
      'percent': faker.randomGenerator.integer(100),
      'count': faker.randomGenerator.integer(1000),
      'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
    }, {
      'image': faker.internet.httpUrl(),
      'answer': faker.randomGenerator.string(20),
      'percent': faker.randomGenerator.integer(100),
      'count': faker.randomGenerator.integer(1000),
      'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
    }],
  };

  static Map makeInvalidApiJson() => {'invalid_key' : 'invalid_value'};

  static List<Map> makeInvalidList() => [
    makeInvalidApiJson(),
    makeInvalidApiJson()
  ];

}

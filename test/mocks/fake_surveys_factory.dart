import 'package:faker/faker.dart';

import 'package:practice/domain/entities/entities.dart';

class FakeSurveysFactory {
  static List<Map> makeCacheJson() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2021-09-20T00:00:00Z',
          'didAnswer': 'false',
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2020-02-18T00:00:00Z',
          'didAnswer': 'true',
        },
      ];

  static List<Map> makeInvalidCacheJson() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalid_date',
          'didAnswer': 'false',
        },
      ];

  static List<Map> makeIncompleteCacheJson() => [
        {
          'date': '2020-02-18T00:00:00Z',
          'didAnswer': 'true',
        }
      ];

  static List<SurveyEntity> makeSurveyEntity() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          date: DateTime.utc(2021, 12, 19),
          didAnswer: true,
        ),
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          date: DateTime.utc(2021, 04, 28),
          didAnswer: false,
        ),
      ];

  static List<Map> makeApiJson() => [
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

  static List<Map> makeInvalidApiJson() => [{'invalid_key' : 'invalid_value'}];
}

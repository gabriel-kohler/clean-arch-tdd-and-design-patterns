import 'package:faker/faker.dart';
import 'package:practice/domain/entities/entities.dart';

class EntityFactory {

  static AccountEntity makeAccountEntity() => AccountEntity(faker.guid.guid());

  static SurveyResultEntity makeSurveyResultEntity() => SurveyResultEntity(
      surveyId: faker.guid.guid(), 
      question: faker.lorem.sentence(), 
      answers: [
        SurveyAnswerEntity(
          image: faker.internet.httpUrl(),
          answer: faker.lorem.sentence(), 
          isCurrentAnswer: true, 
          percent: 40,
        ),
        SurveyAnswerEntity(
          answer: faker.lorem.sentence(), 
          isCurrentAnswer: false, 
          percent: 60,
        ),
      ],
    );

    static List<SurveyEntity> makeSurveysList() => [
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

}

import 'package:meta/meta.dart';
import 'package:practice/domain/entities/entities.dart';

class SurveyResultEntity {
  final String id;
  final String question;
  final List<SurveyAnswerEntity> answers;

  SurveyResultEntity({@required this.id, @required this.question, @required this.answers});


}

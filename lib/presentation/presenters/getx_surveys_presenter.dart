import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '/domain/usecases/usecases.dart';

class GetxSurveysPresenter extends GetxController {

  final LoadSurveys loadSurveys;

  GetxSurveysPresenter({@required this.loadSurveys});

  Future<void> loadData() async {
    await loadSurveys.load();
  }
}
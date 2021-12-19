import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '/domain/usecases/usecases.dart';

class GetxSurveysPresenter extends GetxController {

  final LoadSurveys loadSurveys;

  var isLoading = false.obs;

  Stream<bool> get isLoadingStream => isLoading.stream;

  GetxSurveysPresenter({@required this.loadSurveys});

  Future<void> loadData() async {
    isLoading.value = true;
    await loadSurveys.load();
    isLoading.value = false;
  }
}
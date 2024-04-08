import 'package:chatgpt_mobile_app/constants/api_constants.dart';
import 'package:chatgpt_mobile_app/models/models_model.dart';
import 'package:flutter/material.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = MODEL_ID;
  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];
  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  // Future<List<ModelsModel>> getAllModels() async {
  //   modelsList = await ApiService.getModels();
  //   return modelsList;
  // }
}

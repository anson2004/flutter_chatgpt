import 'package:chatcptapp/services/api_services.dart';
import 'package:flutter/material.dart';
import '../models/models_model.dart';

class ModelsProvider with ChangeNotifier {
  List<ModelsModel> modelLists = [];

  String currentModal = "text-davinci-003";

  List<ModelsModel> get getModelsList {
    return modelLists;
  }

  String get getCurrentModel {
    return currentModal;
  }

  void setCurrentModels(String newModel) {
    currentModal = newModel;
    notifyListeners();
  }

  Future<List<ModelsModel>> getAllModals () async {
    modelLists = await ApiService.getModals();
    return modelLists;
  }
}
import 'package:aifusion/models/models_model.dart';
import 'package:aifusion/services/api_service.dart';
import 'package:flutter/material.dart';

class ModelsProvider with ChangeNotifier{
  
  
  String currentModel="text-davinci-003";


  String get getCurrentModel{
    return currentModel;
  }


  void setCurrentModel(String newModel){
    currentModel=newModel;
    notifyListeners();
  }


  List<ModelsModel> modelsList=[];

  List<ModelsModel> get getModelList{
    return modelsList;
  }

  Future<List<ModelsModel>> getModelsList() async{
    if(modelsList.isEmpty) {
      modelsList = await ApiService.getModels();
    }
    return modelsList;
  }


}
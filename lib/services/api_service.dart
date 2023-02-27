import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aifusion/constants/api_constant.dart';
import 'package:aifusion/models/models_model.dart';
import 'package:http/http.dart' as http;
class ApiService{
  static Future<List<ModelsModel>> getModels() async {
    try{
      var response = await http.get(
        Uri.parse("$BASE_ULR/models"),
        headers: {'Authorization':'Bearer $API_KEY'},
      );

      Map jsonResponse = jsonDecode(response.body);


      if(jsonResponse['error']!=null){
        print("jsonResponse['error'] ${jsonResponse['error']['message']}");
        
        throw HttpException(jsonResponse['error']['message']);
      }

      List temp=[];
      for(var value in jsonResponse['data']){
        temp.add(value);

      }
      return ModelsModel.modelsFromSnapShot(temp);
    }
    catch(error){
      log("error $error");
      rethrow;
    }
  }
}
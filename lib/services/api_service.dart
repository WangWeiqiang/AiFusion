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
        log("jsonResponse['error'] ${jsonResponse['error']['message']}");
        
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


  static Future<void> sendMessage(
    {required String message,required String modelId}) async {
    try{
      var response = await http.post(
        Uri.parse("$BASE_ULR/completions"),
        headers: {
          'Authorization':'Bearer $API_KEY',
          'ContentType':'application/json'
        },
        body:jsonEncode({
          'model':modelId,
          'prompt':message,
          'max_tokens':100
        })
      );

      log("Model $modelId");
      log("msg $message");

      Map jsonResponse = jsonDecode(response.body);


      if(jsonResponse['error']!=null){
        log("jsonResponse['error'] ${jsonResponse['error']['message']}");
        
        throw HttpException(jsonResponse['error']['message']);
      }

      if(jsonResponse['choices'].length>0){
        log(jsonResponse['choices']['text']);
      }

    }
    catch(error){
      log("error $error");
      rethrow;
    }
  }


}
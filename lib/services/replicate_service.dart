import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:aifusion/constants/api_constant.dart';
import 'package:aifusion/models/models_model.dart';
import 'package:http/http.dart' as http;
import 'package:stability_sdk/stability_sdk.dart';

import '../models/chat_model.dart';


class ReplicateService {

  // Get pridication
  static Future<String?> GetSuppResolutionResult({required String url}) async {
    try{
      var uri = Uri.parse(url);
      var response = await http.get(
          uri,
          headers: {
            'Authorization':"Token $REPLICATE_KEY"           
          }
        );

      log(response.body);
      var jsonResponse =convert.jsonDecode(response.body) as Map<String?, dynamic>;
      
      
      return "";// jsonResponse['output'];
    }
    catch(error){
      log("error: $error");
    }
  }
  // Send Message using ChatGPT API
  static Future<String?> SupperResolution({required String modelType,required String imageFile}) async {
    try {
      
      var url = Uri.parse("https://api.replicate.com/v1/predictions");
      var response = await http.post(
          url,
          headers: {
            'Authorization':"Token $REPLICATE_KEY",
            'Content-Type':'application/json',             
          },
          body:jsonEncode({
            'version':'567785261e974455ede3b0644d1d7e5aa8d9e40a22217a8726900acdcd9e19ce',
            'input':{
              'image':imageFile
            }
          })
        );

      //log(response.body);

      var jsonResponse =convert.jsonDecode(response.body) as Map<String?, dynamic>;

      if(!jsonResponse["id"].isEmpty){
        return await GetSuppResolutionResult(url: "https://api.replicate.com/v1/predictions/"+jsonResponse["id"]);
        
      }
      else
        return "";

    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
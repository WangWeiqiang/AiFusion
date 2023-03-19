import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:convert' as convert;
import 'dart:typed_data';
import 'package:aifusion/constants/api_constant.dart';
import 'package:aifusion/models/models_model.dart';
import 'package:aifusion/services/azure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:stability_sdk/stability_sdk.dart';

import '../models/chat_model.dart';


class ReplicateService {

  // Get pridication
  static Future<String?> GetSuppResolutionResult({required String id}) async {
    try{
      var uri = Uri.parse("https://api.replicate.com/v1/predictions/$id");
      var response = await http.get(
          uri,
          headers: {
            'Authorization':"Token $REPLICATE_KEY"           
          }
        );

      log(response.body);
      var jsonResponse =convert.jsonDecode(response.body) as Map<String?, dynamic>;
      
      
      return jsonResponse['output'];
    }
    catch(error){
      log("error: $error");
    }
  }

  static Future<String?> SendRequsst(dynamic input) async{
    try{
      var url = Uri.parse("https://api.replicate.com/v1/predictions");
      var response = await http.post(
          url,
          headers: {
            'Authorization':"Token $REPLICATE_KEY",
            'Content-Type':'application/json',             
          },
          body:jsonEncode(input)
        );

      log(response.body);

      var jsonResponse =convert.jsonDecode(response.body) as Map<String?, dynamic>;

      return jsonResponse["id"];

    } catch (error) {
      log("error $error");
     
    }

  } 

  static Future<String?> SupperResolution({required String fileName,required Uint8List bodyBytes}) async {
   
      var photoUrl = await AzureBlobStorageService.Upload(fileName: fileName, bodyByte: bodyBytes);
      dynamic input = {
        'version':'567785261e974455ede3b0644d1d7e5aa8d9e40a22217a8726900acdcd9e19ce',
            'input':{
              'image':photoUrl
        }
      };

      return await SendRequsst(input);
     
  }

  static Future<String?> Image2Image({required String fileName, required Uint8List? bodyByte,required String prompt,
      required String n_prompt}) async{
    if(bodyByte!=null){
        var photoUrl = await AzureBlobStorageService.Upload(fileName: fileName, bodyByte: bodyByte);
        dynamic input ={
          'version':'435061a1b5a4c1e26740464bf786efdfa9cb3a3ac488595a2de23e143fdb0117',
          'input':{
            'prompt':prompt,
            'num_samples':4,
            'image_resolution':512,
            'ddim_steps':30,
            'scale':9,
            'seed':1,
            'a_prompt':'best quality, extremely detailed',
            'n_prompt':n_prompt,
            "image":photoUrl
          }
      };
      return await SendRequsst(input);
    }
    else{
      return "";
    }

  }
}
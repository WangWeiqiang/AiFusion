import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aifusion/constants/api_constant.dart';
import 'package:aifusion/models/models_model.dart';
import 'package:http/http.dart' as http;
import 'package:stability_sdk/stability_sdk.dart';

import '../models/chat_model.dart';


class Text2ImageService {
  // Send Message using ChatGPT API
  static Future<String?> getImage(
      {required String message}) async {
    try {
      
      // 1. Setup the API client
      final client = StabilityApiClient.init(DREAM_STUDIO_KEY);
      String? image;

      // 2. Create a generation request
      final request = RequestBuilder(message)
          .setHeight(512)
          .setWidth(512)
          .setEngineType(EngineType.inpainting_v2_0)
          .setSampleCount(1)
          .build();

      // 3. Subscribe to the response
      client.generate(request).listen((answer) {
        log("get result");
        image = answer.artifacts?.first.getImage();
        log(image!);
      });

      return image;

    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
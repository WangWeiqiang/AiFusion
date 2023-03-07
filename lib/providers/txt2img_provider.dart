import 'package:flutter/cupertino.dart';

import '../models/chat_model.dart';
import '../services/api_service.dart';
import '../services/txt2img_service.dart';

class Txt2ImgProvider with ChangeNotifier {
  List<String?> imgList = [];
  List<String?> get getImageList {
    return imgList;
  }

  Future<void> sendMessageAndGetImages(
      {required String msg}) async {
    
      imgList.add(await Text2ImageService.getImage(
        message: msg,
        
      ));
    
    notifyListeners();
  }
}